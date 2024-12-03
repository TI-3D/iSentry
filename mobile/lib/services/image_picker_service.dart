import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Fungsi untuk memilih gambar, dengan opsi kamera atau galeri.
  static Future<void> pickImage(
    BuildContext context,
    void Function(List<XFile> images) onImagesPicked,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(LucideIcons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context); // Close dialog
                  if (await _requestPermission(Permission.camera)) {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      onImagesPicked([image]); // Callback with a single image
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    _showPermissionDeniedDialog(context, 'Camera');
                  }
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close dialog
                  if (await _requestPermission(Permission.storage)) {
                    final List<XFile> images = await _picker.pickMultiImage();
                    if (images.isNotEmpty) {
                      onImagesPicked(images); // Callback with multiple images
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    _showPermissionDeniedDialog(context, 'Gallery');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Menampilkan dialog jika izin tidak diberikan.
  static void _showPermissionDeniedDialog(
      BuildContext context, String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: Text(
            'You have denied access to $permissionType. '
            'To continue, enable the permission from app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await openAppSettings(); // Open app settings
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  /// Meminta izin untuk fitur tertentu (kamera/galeri).
  static Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }
}