import 'package:flutter/material.dart';

class DocumentUploadItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? uploadedFilename;
  final VoidCallback onAction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DocumentUploadItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onAction,
    this.uploadedFilename,
    this.onEdit,
    this.onDelete,
  });

  bool get isUploaded => uploadedFilename != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (isUploaded && onEdit != null)
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: onEdit,
                      ),
                    if (isUploaded && onDelete != null)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: onDelete,
                      )
                    else if (!isUploaded)
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 24,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: onAction,
                      ),
                  ],
                ),
              ],
            ),
            if (isUploaded)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        uploadedFilename!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
