import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/face_model.dart';
import 'package:isentry/presentation/home/bloc/faces/face_bloc.dart';
import 'package:isentry/presentation/home/bloc/faces/face_event.dart';
import 'package:isentry/presentation/widgets/components/bottom_sheet.dart';
import 'package:isentry/services/network_service.dart';

class AddDataUnreg extends StatefulWidget {
  final List<FaceModel> selectedFaces; // Daftar wajah yang dipilih

  const AddDataUnreg({required this.selectedFaces, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddDataUnregState createState() => _AddDataUnregState();
}

class _AddDataUnregState extends State<AddDataUnreg> {
  final TextEditingController _nameController =
      TextEditingController();
  bool _isLoading = false; // Track loading state

  Future<void> _uploadData() async {
    if (widget.selectedFaces.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please select at least one face!',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    String name = _nameController.text.trim();
    if (name.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a name!',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var uri = Uri.parse("http://$ipAddress/api/identities");
      var response = await NetworkService.post(
        uri.toString(),
        customHeaders: {'Content-Type': 'application/json'},
        body: {
          'name': name,
          'faceIds': widget.selectedFaces
              .map((face) => face.id)
              .toList(), 
        },
      );

      if (response["success"]) {
        Fluttertoast.showToast(
          msg: 'Data saved successfully!',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        context.read<FaceBloc>().add(LoadUnrecognizedFaces());
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to save data!',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('ini error');
      print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Error: $e',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: "Add Data",
      content: Column(
        children: [
          if (widget.selectedFaces.isNotEmpty)
            Center(
              child: AvatarStack(
                height: 70,
                avatars: widget.selectedFaces.map((face) {
                  return NetworkImage(
                      "http://$ipAddress${face.pictureSinglePath}");
                }).toList(),
              ),
            )
          else
            const Center(
              child: Text(
                "No faces found to display.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController, 
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
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom,
          ),
          child: ElevatedButton(
            onPressed:
                _isLoading ? null : _uploadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 25),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
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
