import 'package:fluffy/modules/auth/otp_screen.dart';
import 'package:fluffy/modules/auth/provider/register_provider.dart';
import 'package:fluffy/modules/auth/register_customer_screens/pet_name_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  final String registerType;
  const RegisterScreen({super.key, required this.registerType});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    print("role ${widget.registerType}");
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    //registerProvider.setRole(widget.registerType);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Join PetCare",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
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

                  const Text(
                    "BASIC INFORMATION",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildTextField(
                    label: "Owner Name",
                    onChanged: registerProvider.setName,
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    label: "Phone",
                    onChanged: registerProvider.setPhone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    label: "Email Address",
                    onChanged: registerProvider.setEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    label: "Password",
                    obscureText: true,
                    onChanged: registerProvider.setPassword,
                  ),
                  const SizedBox(height: 15),

                  _buildTextField(
                    label: "Confirm Password",
                    obscureText: true,
                    onChanged: registerProvider.setConfirmPassword,
                  ),
                  const SizedBox(height: 15),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
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
                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_agreeToTerms) {
                          if (_formKey.currentState!.validate()) {
                            bool success = await registerProvider.register(
                              widget.registerType,
                            );

                            if (success) {
                              // Navigate to OTP screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => OtpVerificationPage(
                                        registerType: widget.registerType,
                                      ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Registration failed. Please try again.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
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
                        "Continue to Business Setup",
                        style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildTextField({
    required String label,
    bool obscureText = false,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please enter $label' : null,
      onChanged: onChanged,
    );
  }
}
