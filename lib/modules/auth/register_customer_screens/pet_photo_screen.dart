import 'dart:io';

import 'package:fluffy/modules/auth/register_customer_screens/pet_setup_complete.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetPhotoScreen extends StatefulWidget {
  const PetPhotoScreen({super.key});

  @override
  State<PetPhotoScreen> createState() => _PetPhotoScreenState();
}

class _PetPhotoScreenState extends State<PetPhotoScreen> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Let’s see that cute face of Bruno",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: _pickImage,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9BA1), Color(0xFFFFC4CC)],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!)
                              : const AssetImage("assets/dog.jpg")
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Edit",
                    style: TextStyle(
                      color: Color(0xFFFF758C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PetSetupCompleteScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF758C),
                    disabledBackgroundColor: const Color(0xFFFFC4CC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
