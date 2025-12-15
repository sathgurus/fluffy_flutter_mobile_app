import 'package:fluffy/modules/auth/otp_screen.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/model/business_user_model.dart';
import 'package:fluffy/modules/auth/provider/register_provider.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:fluffy/modules/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BusinessRegisterScreen extends StatefulWidget {
  const BusinessRegisterScreen({super.key});

  @override
  State<BusinessRegisterScreen> createState() => _BusinessRegisterScreenState();
}

class _BusinessRegisterScreenState extends State<BusinessRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final businessNameCtrl = TextEditingController();
  final businessTypeCtrl = TextEditingController();
  final businessPhoneCtrl = TextEditingController();
  final altPhoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  bool termsAccepted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      appBar: appBarWithBackButton(context, "Join PetCare"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create your business account to reach thousands of pet parents.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _field("Name", nameCtrl),
                  const SizedBox(height: 20),
                  _field("Business Name", businessNameCtrl),
                  const SizedBox(height: 20),
                  _field("Business Type", businessTypeCtrl),
                  const SizedBox(height: 20),
                  _field("Business Phone", businessPhoneCtrl),
                  const SizedBox(height: 20),
                  _field("Alternate Phone", altPhoneCtrl, requiredField: false),
                  const SizedBox(height: 20),
                  _field("Business Email", emailCtrl, requiredField: false),
                  const SizedBox(height: 20),
                  _field("Business Website", websiteCtrl, requiredField: false),
                  const SizedBox(height: 20),
                  _field("Password", passwordCtrl, isPassword: true),
                  const SizedBox(height: 20),
                  _field(
                    "Confirm Password",
                    confirmPasswordCtrl,
                    isPassword: true,
                  ),

                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: termsAccepted,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            termsAccepted = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Wrap(
                          children: const [
                            Text(
                              "I agree to Terms of Service & Privacy Policy",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        if (!termsAccepted) {
                          ToastificationShowError.showToast(
                            context: context,
                            description: "Please accept Terms & Conditions",
                          );
                          return;
                        }

                        BusinessUserModel user = BusinessUserModel(
                          name: nameCtrl.text,
                          businessName: businessNameCtrl.text,
                          businessType: businessTypeCtrl.text,
                          businessPhone: businessPhoneCtrl.text,
                          altPhone: altPhoneCtrl.text,
                          businessEmail: emailCtrl.text,
                          businessWebsite: websiteCtrl.text,
                          password: passwordCtrl.text,
                          confirmPassword: confirmPasswordCtrl.text,
                          termsAccepted: termsAccepted,
                        );

                        bool result = await provider.register(user);

                        if (result) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const OtpVerificationPage(
                                    registerType: "owner",
                                  ),
                            ),
                          );

                          ToastificationShow.showToast(
                            context: context,
                            title: "Registration",
                            description: "Business registered successfully.",
                          );
                        } else {
                          ToastificationShowError.showToast(
                            context: context,
                            description:
                                "Registration failed. Please try again later.",
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool isPassword = false,
    bool requiredField = true,
    TextEditingController? compareWith,
  }) {
    bool isPhoneField = label.toLowerCase().contains("phone");

    return TextFormField(
      controller: ctrl,
      obscureText: isPassword,

      validator: (v) {
        if (requiredField && (v == null || v.isEmpty)) {
          return "$label is required";
        }

        if (isPhoneField && v!.isNotEmpty && v.length != 10) {
          return "Enter a valid 10-digit number";
        }

        /// PASSWORD VALIDATION
        if (isPassword && label == "Password") {
          return validatePassword(v!);
        }

        /// CONFIRM PASSWORD VALIDATION
        if (label == "Confirm Password") {
          if (v != passwordCtrl.text) {
            return "Passwords do not match";
          }
        }

        return null;
      },

      keyboardType: isPhoneField ? TextInputType.number : TextInputType.text,
      maxLength: isPhoneField ? 10 : null,
      inputFormatters:
          isPhoneField ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        counterText: "",
        label: RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: textSizeSmall,
              color: Colors.black87,
            ),
            children:
                requiredField
                    ? const [
                      TextSpan(text: " *", style: TextStyle(color: Colors.red)),
                    ]
                    : [],
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return "Password is required";
  }
  if (value.length < 8) {
    return "Password must be at least 8 characters";
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "Password must contain 1 uppercase letter";
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return "Password must contain 1 lowercase letter";
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return "Password must contain 1 number";
  }
  if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
    return "Password must contain 1 special character";
  }
  return null;
}
