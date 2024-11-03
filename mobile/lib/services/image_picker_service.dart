import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<void> pickImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  if (await _requestPermission(Permission.camera)) {
                    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      // Handle the selected image file
                    }
                  } else {
                    // Show error or info that permission was denied
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  if (await _requestPermission(Permission.photos)) {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      // Handle the selected image file
                    }
                  } else {
                    // Show error or info that permission was denied
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }
}