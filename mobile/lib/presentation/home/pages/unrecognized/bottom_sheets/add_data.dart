import 'package:flutter/material.dart';
import 'package:isentry/presentation/widgets/components/bottom_sheet.dart';
import 'package:isentry/services/image_picker_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddDataBottomSheet extends StatelessWidget {
  const AddDataBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableBottomSheet(
      title: "Add Data",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: InkWell(
              onTap: () => ImagePickerService.pickImage(context),
              child: Container(
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
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Nama',
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
                  width: 1.0,
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
        child: ElevatedButton(
          onPressed: () {
            // Logika penyimpanan data
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
    );
  }
}
