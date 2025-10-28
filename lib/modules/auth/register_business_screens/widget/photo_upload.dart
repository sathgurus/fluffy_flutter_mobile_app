import 'package:flutter/material.dart';

class PhotoUploadBox extends StatelessWidget {
  final double size;
  final Color? color; // Changed from imageUrl
  final VoidCallback onClick;

  const PhotoUploadBox({
    super.key,
    this.size = 100,
    this.color, // Takes a color instead of a network image URL
    required this.onClick, String? imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    bool isFilled = color != null; // Check if it has a color (i.e., is 'uploaded')

    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        // FIX: Replaced NetworkImage with simple color for stability
        decoration: BoxDecoration(
          color: isFilled ? color : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: isFilled
              ? null
              : Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
          boxShadow: isFilled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: isFilled
            ? const Center(
                // Mock visual representation of an uploaded photo
                child: Icon(Icons.image, size: 40, color: Colors.white70),
              )
            : const Center(
                child: Icon(Icons.add, size: 30, color: Colors.grey),
              ),
      ),
    );
  }
}