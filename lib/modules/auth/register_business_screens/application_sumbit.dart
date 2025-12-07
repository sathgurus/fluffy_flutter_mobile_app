import 'package:fluffy/modules/auth/login.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/dashoboard/home.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:flutter/material.dart';

class ApplicationSubmittedScreen extends StatefulWidget {
  const ApplicationSubmittedScreen({super.key});

  @override
  State<ApplicationSubmittedScreen> createState() =>
      _ApplicationSubmittedScreenState();
}

class _ApplicationSubmittedScreenState
    extends State<ApplicationSubmittedScreen> {
  @override
  Widget build(BuildContext context) {
    // Determine the screen width for responsive sizing, if needed.
    // However, the current design is largely fixed-width in its elements.
    final double screenWidth = MediaQuery.of(context).size.width;

    // Define the primary color for the button and text (appears pink/salmon in the image)
    const Color primaryColor = Color(
      0xFFF78B94,
    ); // Approximation of the button color

    return Scaffold(
      appBar: appBarWithBackButton(context, "Application subimt"),
      // Padding only for the main content area
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Main Heading
              const Text(
                'Application Submitted!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtext
              const Text(
                'Your shop profile is now under review by our team.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Image/Illustration Placeholder
              Center(
                child: SizedBox(
                  width: screenWidth * 0.7, // Adjust size as needed
                  child: AspectRatio(
                    aspectRatio: 1, // Placeholder for a square image
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors
                                .grey[100], // Light background for the image area
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // You would replace this with an Image.asset, Image.network, or an SvgPicture
                      // using the actual pet care illustration.
                      child: Center(
                        child: Image.asset(
                          'assets/fluffy1.jpeg',
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //  // Use this tag to indicate where the image should be placed
              const SizedBox(height: 32),

              // Review Information
              const Text(
                "We'll review your information and contact you within 24-48 hours.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),

              const SizedBox(height: 16),

              // Verification Contact
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Verification Contact:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        '(+91) 9874561230',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const Text(
                        ' | ',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        'support@petcareapp.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryColor, // Use the app's primary color
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // What happens next section
              const Text(
                'What happens next?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Steps
              _buildNumberedListItem(
                '1. We\'ll verify your documents & location.',
              ),
              _buildNumberedListItem('2. We\'ll get notified once approved.'),
              _buildNumberedListItem('3. Start taking bookings.'),

              const SizedBox(height: 40),

              // Done Button (Expanded to fill width)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginTabsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // The salmon/pink color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Rounded corners
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Footer Text
              Center(
                child: Text(
                  'Thank you for joining the PetCare family',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40), // Bottom spacing for safe area
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build the numbered list items
  Widget _buildNumberedListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
