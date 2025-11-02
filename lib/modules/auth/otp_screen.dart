import 'dart:async';
import 'package:fluffy/modules/auth/provider/register_provider.dart';
import 'package:fluffy/modules/auth/register_business_screens/add_business.dart';
import 'package:fluffy/modules/auth/register_customer_screens/pet_name_screen.dart';
import 'package:fluffy/modules/auth/register_customer_screens/pet_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpVerificationPage extends StatefulWidget {
  final String registerType;
  const OtpVerificationPage({super.key, required this.registerType});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  int seconds = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    setState(() => seconds = 30);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        setState(() => seconds--);
      }
    });
  }

  Widget buildOtpBox(String value) {
    return Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: const Color(0xffF4B3B3), width: 1.5),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildCustomKeyboard(RegisterProvider registerProvider) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['←', '0', 'Done'],
    ];

    return Column(
      children:
          keys.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    row.map((key) {
                      return GestureDetector(
                        onTap: () async {
                          if (key == '←') {
                            registerProvider.removeLastOtp();
                          } else if (key == 'Done') {
                            bool success = await registerProvider.verifyOtp();
                            if (success) {
                              if (widget.registerType == "business_owner") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AddBusinessScreen(),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PetNameScreen(),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Invalid OTP")),
                              );
                            }
                          } else {
                            registerProvider.appendOtp(key);
                          }
                        },
                        child: Container(
                          width: 90,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xffE5E5E5)),
                          ),
                          child: Text(
                            key,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            );
          }).toList(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF7F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "OTP Verification",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Consumer<RegisterProvider>(
        builder: (context, registerProvider, _) {
          return SafeArea(
            child: LayoutBuilder(
              builder:
                  (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                "Enter the verification code we just sent to your mobile number",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(5, (index) {
                                  final value =
                                      registerProvider.otp.length > index
                                          ? registerProvider.otp[index]
                                          : "";
                                  return buildOtpBox(value);
                                }),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                seconds > 0
                                    ? "Resend OTP in ${seconds}s"
                                    : "Didn’t receive the code?",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 25),
                              OutlinedButton(
                                onPressed:
                                    seconds == 0
                                        ? () {
                                          startTimer();
                                          registerProvider.clearOtp();
                                        }
                                        : null,
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  side: const BorderSide(
                                    color: Color(0xffF79B9B),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Resend OTP",
                                  style: TextStyle(
                                    color: Color(0xffF79B9B),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              buildCustomKeyboard(registerProvider),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
}
