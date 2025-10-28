
import 'package:fluffy/modules/auth/register_business_screens/application_sumbit.dart';
import 'package:fluffy/modules/auth/register_business_screens/widget/document_upload.dart';
import 'package:fluffy/modules/auth/register_business_screens/widget/photo_upload.dart';
import 'package:flutter/material.dart';


class AddPersonalDetails extends StatefulWidget {
  const AddPersonalDetails({super.key});

  @override
  State<AddPersonalDetails> createState() => _AddPersonalDetailsState();
}

class _AddPersonalDetailsState extends State<AddPersonalDetails> {
  Map<String, String?> uploadedDocuments = {
    'gst': 'GST0125.pdf', // Mock uploaded
    'pan': null,
    'aadhaar': null,
    'address': null,
  };

  List<String?> shopPhotos = [
    'https://placehold.co/150x150/f0f9ff/0284c7?text=Shop+Photo+1', // Mock uploaded
    null,
    null,
  ];

  String? logoUrl; // No logo uploaded initially

  bool get isFormValid =>
      uploadedDocuments.values.every((name) => name != null) &&
      shopPhotos.where((url) => url != null).length >= 3 &&
      logoUrl != null;

  void _handleUpload(String key) {
    // In a real app, this would open a file picker
    setState(() {
      uploadedDocuments[key] = 'New-${key.toUpperCase()}.pdf';
    });
  }

  void _handlePhotoUpload(int index, {bool isLogo = false}) {
    // In a real app, this would open a camera/gallery
    setState(() {
      if (isLogo) {
        logoUrl = 'https://placehold.co/150x150/ccfbf1/0f766e?text=Logo';
      } else {
        shopPhotos[index] =
            'https://placehold.co/150x150/f0f9ff/0284c7?text=Photo+${index + 1}';
      }
    });
  }

  void _handleSubmit() {
    // if (isFormValid) {
    // Logic for submitting the form
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Submission'),
            content: const Text('Form submitted for review!'),
            actions: [
              TextButton(
                onPressed:
                    () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ApplicationSubmittedScreen(),
                        ),
                      ),
                    },
                child: const Text('OK'),
              ),
            ],
          ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () {
            // Navigator.pop(context); // Go back action
          },
        ),
        title: const Text(
          'Add Your Business (Step 4 of 4)',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: LinearProgressIndicator(
            value: 1.0, // Represents Step 4 of 4 (100% complete)
            backgroundColor: Colors.purple.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.deepPurple.shade600,
            ),
            minHeight: 3.0,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  const Text(
                    'Verify & Personalize Your Shop',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Just few more things before we verify you!',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 20),

                  // --- Document Uploads ---
                  DocumentUploadItem(
                    title: 'GST Document',
                    subtitle: 'Mock: Uploaded GST0125.pdf',
                    uploadedFilename: uploadedDocuments['gst'],
                    onAction: () => _handleUpload('gst'),
                    onEdit: () => _handleUpload('gst'),
                    onDelete:
                        () => setState(() => uploadedDocuments['gst'] = null),
                  ),
                  DocumentUploadItem(
                    title: 'PAN',
                    subtitle: 'Tap to upload photo or PDF (max 5MB).',
                    uploadedFilename: uploadedDocuments['pan'],
                    onAction: () => _handleUpload('pan'),
                    onEdit: () => _handleUpload('pan'),
                    onDelete:
                        () => setState(() => uploadedDocuments['pan'] = null),
                  ),
                  DocumentUploadItem(
                    title: 'Aadhaar Card',
                    subtitle: 'Tap to upload photo or PDF (max 5MB).',
                    uploadedFilename: uploadedDocuments['aadhaar'],
                    onAction: () => _handleUpload('aadhaar'),
                    onEdit: () => _handleUpload('aadhaar'),
                    onDelete:
                        () =>
                            setState(() => uploadedDocuments['aadhaar'] = null),
                  ),
                  DocumentUploadItem(
                    title: 'Proof of Address',
                    subtitle: 'Tap to upload photo or PDF (max 5MB).',
                    uploadedFilename: uploadedDocuments['address'],
                    onAction: () => _handleUpload('address'),
                    onEdit: () => _handleUpload('address'),
                    onDelete:
                        () =>
                            setState(() => uploadedDocuments['address'] = null),
                  ),
                  const SizedBox(height: 16),

                  // --- Business Photo ---
                  const Text(
                    'Business Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add Shop Logo',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  PhotoUploadBox(
                    size: 100, // Logo size
                    imageUrl: logoUrl,
                    onClick: () => _handlePhotoUpload(0, isLogo: true),
                  ),
                  const SizedBox(height: 24),

                  // --- Shop Photos ---
                  const Text(
                    'Shop Photos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to add photos of your storefront, interior, and services',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),

                  // Photo Grid
                  GridView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // To allow main scroll view to handle scrolling
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: shopPhotos.length,
                    itemBuilder: (context, index) {
                      return PhotoUploadBox(
                        size: double.infinity,
                        imageUrl: shopPhotos[index],
                        onClick: () => _handlePhotoUpload(index),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ), // Extra padding before the bottom button area
                ],
              ),
            ),
          ),

          // --- Persistent Bottom Button ---
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 5,
                ),
                child: const Text('Submit for Review'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
