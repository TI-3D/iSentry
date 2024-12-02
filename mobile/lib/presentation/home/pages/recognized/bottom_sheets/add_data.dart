import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isentry/presentation/widgets/components/bottom_sheet.dart';
import 'package:isentry/services/image_picker_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final List<XFile> _selectedImages = [];

  void _updateImages(XFile image) {
    setState(() {
      _selectedImages.add(image);  // Add selected image to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: "Add Data",
      content: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () => ImagePickerService.pickImage(context, _updateImages as void Function(List<XFile> images)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_selectedImages.isNotEmpty)
                    ..._selectedImages.asMap().entries.map((entry) {
                      int index = entry.key;
                      XFile image = entry.value;
                      return Positioned(
                        left: index * 25.0, // Adjust position for stacking
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(File(image.path)),
                        ),
                      );
                    }),
                  if (_selectedImages.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.camera,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            focusNode: _focusNode,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 15.0,
              ),
            ),
          ),
        ],
      ),
      actionButton: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust padding for keyboard
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 25),
            ),
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
