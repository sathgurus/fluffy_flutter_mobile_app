import 'package:fluffy/modules/auth/register_customer_screens/pet_gender_screen.dart';
import 'package:flutter/material.dart';

class PetAgeScreen extends StatefulWidget {
  const PetAgeScreen({super.key});

  @override
  State<PetAgeScreen> createState() => _PetAgeScreenState();
}

class _PetAgeScreenState extends State<PetAgeScreen> {
  double age = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Pet avatar with gradient circle
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

            const SizedBox(height: 20),

            const Text(
              "How old is Bruno?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 40),

            // Slider Label
            Text(
              "Slider (months/years)",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),

            const SizedBox(height: 25),

            // Age Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Slider(
                    value: age,
                    min: 0,
                    max: 15,
                    divisions: 15,
                    activeColor: const Color(0xFFFF758C),
                    inactiveColor: const Color(0xFFFFC4CC),
                    label: "${age.toInt()} yr",
                    onChanged: (value) {
                      setState(() {
                        age = value;
                      });
                    },
                  ),
                  Text(
                    "${age.toInt()} Years",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF758C),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Next Button
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
                        builder: (_) => const PetGenderScreen(),
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
