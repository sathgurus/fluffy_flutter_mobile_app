import 'package:fluffy/modules/auth/register_customer_screens/pet_photo_screen.dart';
import 'package:flutter/material.dart';

class PetNoteScreen extends StatefulWidget {
  const PetNoteScreen({super.key});

  @override
  State<PetNoteScreen> createState() => _PetNoteScreenState();
}

class _PetNoteScreenState extends State<PetNoteScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
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
                backgroundImage: AssetImage("assets/dog.jpg"),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Anything we should know about Bruno?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFF758C),
                    width: 1.3,
                  ),
                ),
                child: TextField(
                  controller: _notesController,
                  onChanged: (_) => setState(() {}),
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "e.g., nervous during bath, allergies, etc.",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
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
                      MaterialPageRoute(builder: (_) => const PetPhotoScreen()),
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
