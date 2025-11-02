import 'package:fluffy/modules/auth/register_customer_screens/pet_age_screen.dart';
import 'package:flutter/material.dart';

class PetBreedScreen extends StatefulWidget {
  const PetBreedScreen({super.key});

  @override
  State<PetBreedScreen> createState() => _PetBreedScreenState();
}

class _PetBreedScreenState extends State<PetBreedScreen> {
  TextEditingController searchController = TextEditingController();

  List<String> breeds = [
    "Breed name",
    "Breed name",
    "Breed name",
    "Breed name",
    "Breed name",
  ];

  String? selectedBreed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

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
                backgroundImage: AssetImage("assets/dog.jpg"),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "What's Bruno’s breed?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 25),

            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search breed name",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: const Color(0xFFFFEEF0),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFFC4CC),
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF758C),
                      width: 1.3,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),

            const SizedBox(height: 20),

            // Breed List
            Expanded(
              child: ListView.builder(
                itemCount: breeds.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  String breed = breeds[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFC4CC),
                        width: 1.2,
                      ),
                    ),
                    child: RadioListTile<String>(
                      value: breed,
                      groupValue: selectedBreed,
                      activeColor: const Color(0xFFFF758C),
                      title: Text(
                        breed,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => selectedBreed = value);
                      },
                    ),
                  );
                },
              ),
            ),

            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PetAgeScreen()),
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
          ],
        ),
      ),
    );
  }
}
