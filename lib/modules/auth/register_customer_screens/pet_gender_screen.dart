import 'package:fluffy/modules/auth/register_customer_screens/pet_note_screen.dart';
import 'package:flutter/material.dart';

class PetGenderScreen extends StatefulWidget {
  const PetGenderScreen({super.key});

  @override
  State<PetGenderScreen> createState() => _PetGenderScreenState();
}

class _PetGenderScreenState extends State<PetGenderScreen> {
  String? selectedGender;

  final List<String> genders = ["Male", "Female"];
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
              "Is Bruno a boy or a girl?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 40),

            // Gender buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children:
                    genders.map((gender) {
                      bool isSelected = selectedGender == gender;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => selectedGender = gender);
                          },
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFFFF758C)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFF758C),
                                width: 1.4,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              gender,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Color(0xFFFF758C),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
                      MaterialPageRoute(builder: (_) => const PetNoteScreen()),
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
