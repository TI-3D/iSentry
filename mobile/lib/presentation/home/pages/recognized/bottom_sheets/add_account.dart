import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/presentation/auth/bloc/login_bloc.dart';
import 'package:isentry/presentation/auth/bloc/login_event.dart';
import 'package:isentry/presentation/widgets/components/bottom_sheet.dart';

class AddAccount extends StatefulWidget {
  final int identityId;
  final String userId;
  final String name;
  const AddAccount(
      {super.key,
      required this.name,
      required this.userId,
      required this.identityId});

  @override

  // ignore: library_private_types_in_public_api
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: "Add Account",
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextField(
              controller: _username..text = widget.name.replaceAll(' ', ''),
              cursorColor: Colors.black,
              decoration: InputDecoration(
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
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextField(
              controller: _password,
              focusNode: _focusNode,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'password',
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
          ),
        ],
      ),
      actionButton: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            right: 5,
          ),
          child: ElevatedButton(
            onPressed: () {
              if (_username.text.isEmpty || _password.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("data ada yang kosong"),
                    duration: Duration(seconds: 3),
                  ),
                );
                return;
              }

              context.read<LoginBloc>().add(
                    SignupSubmitted(
                      name: widget.name,
                      username: _username.text,
                      password: _password.text,
                      role: 'RESIDENT',
                      ownerId: int.parse(widget.userId),
                      identityId: widget.identityId,
                    ),
                  );

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Berhasil membuat akun resident'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 25),
            ),
            child: const Text(
              "Add",
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
