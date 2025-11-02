import 'package:fluffy/modules/auth/register_customer_screens/pet_type_screen.dart';
import 'package:flutter/material.dart';

class PetNameScreen extends StatefulWidget {
  const PetNameScreen({super.key});

  @override
  State<PetNameScreen> createState() => _PetNameScreenState();
}

class _PetNameScreenState extends State<PetNameScreen> {
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9EDED), // Light Pink Background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),

            // Pet Avatar
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9BA1), Color(0xFFFFC4CC)],
                ),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  "assets/dog.jpg",
                ), // Place an image here
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              "What's your pet’s name?",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xffD44A4A),
              ),
            ),

            const SizedBox(height: 20),

            // TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "e.g., “Bruno, Coco, Simba…t”",
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xffFF7A7A),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xffFF4C4C),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    //if (nameController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PetTypeScreen()),
                    );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF7A7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
