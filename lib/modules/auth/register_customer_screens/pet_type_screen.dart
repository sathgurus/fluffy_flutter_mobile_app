import 'package:fluffy/modules/auth/register_customer_screens/pet_breed_screen.dart';
import 'package:flutter/material.dart';

class PetTypeScreen extends StatefulWidget {
  const PetTypeScreen({super.key});

  @override
  State<PetTypeScreen> createState() => _PetTypeScreenState();
}

class _PetTypeScreenState extends State<PetTypeScreen> {
    String? selectedType;

  final List<String> options = [
    "Dog",
    "Cat",
    "Birds",
    "Others",
  ];
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
                backgroundImage: AssetImage("assets/dog.jpg"), // Place an image here
              ),
            ),

            const SizedBox(height: 15),

            // Question
            const Text(
              "What kind of pet is Bruno?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 30),

            // Selection options grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (_, index) {
                  String option = options[index];
                  bool isSelected = option == selectedType;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedType = option;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFFF758C) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF758C),
                          width: 1.4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Color(0xFFFF758C),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PetBreedScreen()),
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