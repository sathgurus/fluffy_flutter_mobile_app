import 'package:fluffy/modules/auth/login.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessNotVerifiedScreen extends StatefulWidget {
  final String message;
  const BusinessNotVerifiedScreen({super.key, required this.message});

  @override
  State<BusinessNotVerifiedScreen> createState() =>
      _BusinessNotVerifiedScreenState();
}

class _BusinessNotVerifiedScreenState extends State<BusinessNotVerifiedScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userVerify = prefs.getString('userVerify');
    debugPrint("userVerify: $userVerify");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackButton(context, "Verification Status"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color(0xFFFFE5E5),
          //     Color(0xFFFFFFFF),
          //   ],
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              elevation: 8,
              shadowColor: Colors.redAccent.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🚫 Icon with background
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_outlined,
                        color: Colors.redAccent,
                        size: 64,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ❗ Title
                    const Text(
                      "Business Not Verified",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // 📌 Message
                    Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // 🔁 Retry Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginTabsScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Retry Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 📞 Support
                    TextButton(
                      onPressed: () {
                        // TODO: Add support action
                      },
                      child: const Text(
                        "Contact Support",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
