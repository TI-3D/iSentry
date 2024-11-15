import 'package:flutter/material.dart';
import 'package:isentry/presentation/widgets/components/bottom_sheet.dart';
import 'package:isentry/services/image_picker_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddDataUnreg extends StatefulWidget {
  const AddDataUnreg({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddDataUnregState createState() => _AddDataUnregState();
}

class _AddDataUnregState extends State<AddDataUnreg> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: "Add Data",
      content: Column(
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
            focusNode: _focusNode,
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
            bottom: MediaQuery.of(context).viewInsets.bottom, // Tambahkan padding agar tidak tertutup keyboard
          ),
          child: ElevatedButton(
            onPressed: () {
              // Logika penyimpanan data
              Navigator.of(context).pop(); // Tutup bottom sheet setelah data disimpan
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
