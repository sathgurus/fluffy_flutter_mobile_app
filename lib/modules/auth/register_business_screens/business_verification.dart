import 'dart:io';
import 'package:fluffy/modules/auth/register_business_screens/add_service.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/business_verification_provider.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessVerification extends StatefulWidget {
  const BusinessVerification({super.key});

  @override
  State<BusinessVerification> createState() => _BusinessVerificationState();
}

class _BusinessVerificationState extends State<BusinessVerification> {
  final _formKey = GlobalKey<FormState>();

  final tinCtrl = TextEditingController();
  final gstCtrl = TextEditingController();
  final panCtrl = TextEditingController();
  final aadhaarCtrl = TextEditingController();

  final ImagePicker picker = ImagePicker();

  String? userId;

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString("userId");
    });

    print("User ID: $userId");
  }

  // ------------------------ PICK IMAGE ------------------------
  Future<String?> pickImageFromGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      return File(picked.path).path; // Return file path
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BusinessVerificationProvider>(context);

    return Scaffold(
      appBar: appBarWithBackButton(context, "Add Personal Information"),
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
              key: _formKey, // 🔥 FORM START
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------- GST (OPTIONAL) -----------
                  TextFormField(
                    controller: gstCtrl,
                    style: const TextStyle(
                      fontSize: textSizeSmall,
                      color: Colors.black87,
                    ),
                    decoration: _inputDecoration("GST Number"),
                    validator: (v) => null, // optional
                    onChanged: provider.updateGST,
                  ),
                  const SizedBox(height: 20),

                  // -------- PAN (OPTIONAL) -----------
                  TextFormField(
                    controller: panCtrl,
                    style: const TextStyle(
                      fontSize: textSizeSmall,
                      color: Colors.black87,
                    ),
                    decoration: _inputDecoration("PAN Number"),
                    validator: (v) => null, // optional
                    onChanged: provider.updatePAN,
                  ),
                  const SizedBox(height: 20),

                  // -------- Aadhaar (REQUIRED)-----------
                  TextFormField(
                    controller: aadhaarCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: textSizeSmall,
                      color: Colors.black87,
                    ),
                    decoration: _inputDecoration("Aadhaar Number"),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Aadhaar number is required";
                      }
                      if (v.length != 12) {
                        return "Aadhaar must be 12 digits";
                      }
                      return null;
                    },
                    onChanged: provider.updateAadhaar,
                  ),
                  const SizedBox(height: 20),

                  // -------- TIN (OPTIONAL) -----------
                  TextFormField(
                    controller: tinCtrl,
                    style: const TextStyle(
                      fontSize: textSizeSmall,
                      color: Colors.black87,
                    ),
                    decoration: _inputDecoration("TIN Number"),
                    validator: (v) => null,
                    onChanged: provider.updateTIN,
                  ),

                  const SizedBox(height: 25),

                  // -------- LOGO (REQUIRED) ----------
                  const Text(
                    "Business Logo",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {
                      String? imagePath = await pickImageFromGallery();
                      if (imagePath != null) {
                        provider.updateLogo(imagePath);
                      }
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                        image:
                            provider.verificationData.logoUrl != null
                                ? DecorationImage(
                                  image: FileImage(
                                    File(provider.verificationData.logoUrl!),
                                  ),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          provider.verificationData.logoUrl == null
                              ? Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey.shade400,
                                ),
                              )
                              : null,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // -------- SHOP PHOTOS (OPTIONAL) ----------
                  const Text(
                    "Shop Photos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemBuilder: (_, index) {
                      final imgPath =
                          provider.verificationData.shopPhotos[index];

                      return GestureDetector(
                        onTap: () async {
                          String? imagePath = await pickImageFromGallery();
                          if (imagePath != null) {
                            provider.updateShopPhoto(index, imagePath);
                          }
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                            image:
                                imgPath != null
                                    ? DecorationImage(
                                      image: FileImage(File(imgPath)),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              imgPath == null
                                  ? Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                  : null,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // ------------------------ SUBMIT ------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _onSubmit(provider);
                      },
                      child: TextWidget(
                        text: "Continue",
                        color: AppColors.whiteColor,
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

  void _onSubmit(BusinessVerificationProvider provider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (provider.verificationData.logoUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Business logo is required")),
      );
      return;
    }
    provider.loadUserId();
    bool result = await provider.businessVerify(userId);

    if (result) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AddServices()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Business verification successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Business verification failed")),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      label: TextWidget(
        text: label,
        fontSize: textSizeSmall,
        color: Colors.black87,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }
}
