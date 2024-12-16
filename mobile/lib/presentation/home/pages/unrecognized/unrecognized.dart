import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/face_model.dart';
import 'package:isentry/presentation/home/bloc/faces/face_bloc.dart';
import 'package:isentry/presentation/home/bloc/faces/face_event.dart';
import 'package:isentry/presentation/home/bloc/faces/face_state.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'bottom_sheets/add_data.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';

class UnrecognizedPage extends StatefulWidget {
  const UnrecognizedPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UnrecognizedPageState createState() => _UnrecognizedPageState();
}

class _UnrecognizedPageState extends State<UnrecognizedPage> {
  List<bool> _isSelected = [];
  final List<FaceModel> _selectedFaces = [];
  bool _multiSelectMode = false;

  Future<void> _openAddDataUnreg() async {
    bool? reload = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDataUnreg(selectedFaces: _selectedFaces),
      ),
    );

    if (reload == true) {
      print("Reload triggered from AddDataUnreg.");
      setState(() {
        _selectedFaces.clear();
        _isSelected = List.filled(_isSelected.length, false);
        _multiSelectMode = false;
      });
    }
  }

  void _loadUnrecognizedFaces() {
    context.read<FaceBloc>().add(LoadUnrecognizedFaces());
  }

  // Method to show bottom sheet with selected faces
  void _showAddDataBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddDataUnreg(selectedFaces: List.from(_selectedFaces)),
    );
  }

  void _onFabPressed() {
    _showAddDataBottomSheet(context);
  }

  // Function to handle unselect all items and disable multi-select mode
  void _unselectAll() {
    setState(() {
      // Unselect all faces and clear selectedFaces
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = false;
      }
      _selectedFaces.clear();
      // Disable multi-select mode if no faces are selected
      _multiSelectMode = false;
    });
  }

  @override
  void initState() {
    context.read<FaceBloc>().add(LoadUnrecognizedFaces());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff1f4f9),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: MySort(
            texts: const ['Today', 'Week', 'Month', 'Year'],
            leftPadding: 25,
            rightPadding: 25,
            onItemSelected: (int) {
              0;
            },
          ),
        ),
      ),
      body: BlocBuilder<FaceBloc, FaceState>(
        builder: (context, state) {
          if (state is FaceLoading || state is FaceReloading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FaceLoaded) {
            // Handle the faces data after reload
            if (_isSelected.length != state.faces.length) {
              _isSelected = List.filled(state.faces.length, false);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.faces.length,
                itemBuilder: (context, index) {
                  final face = state.faces[index];
                  final formattedDate =
                      DateFormat("d MMMM yyyy, HH:mm").format(face.createdAt);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_multiSelectMode) {
                            // Toggle selection in multi-select mode
                            setState(() {
                              if (_isSelected[index]) {
                                _selectedFaces
                                    .removeWhere((f) => f.id == face.id);
                              } else {
                                _selectedFaces.add(face);
                              }
                              _isSelected[index] = !_isSelected[index];
                            });

                            // If all faces are unselected, disable multi-select mode
                            if (_selectedFaces.isEmpty) {
                              setState(() {
                                _multiSelectMode = false;
                              });
                            }
                          } else {
                            // Single selection mode
                            setState(() {
                              // Clear previous selections
                              _selectedFaces.clear();
                              _isSelected = List.filled(_isSelected.length,
                                  false); // Reset all selections
                              _selectedFaces.add(face);
                              _isSelected[index] =
                                  true; // Mark the current face as selected
                            });
                            _showAddDataBottomSheet(context);
                          }
                        },
                        onLongPress: () {
                          setState(() {
                            if (!_multiSelectMode) {
                              // Enable multi-select mode and reset previous selections
                              _multiSelectMode = true;
                              _selectedFaces.clear();
                              _isSelected = List.filled(_isSelected.length,
                                  false); // Reset all selections
                            }
                            // Add the current face to the selection
                            _isSelected[index] = true;
                            _selectedFaces.add(face);
                          });
                        },
                        child: Card(
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "http://$ipAddress${face.pictureSinglePath}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    if (_multiSelectMode)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Icon(
                                          _isSelected[index]
                                              ? Icons.check_circle
                                              : Icons.circle_outlined,
                                          color: _isSelected[index]
                                              ? Colors.black
                                              : Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Face#${face.id}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.calendarDays,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else if (state is FaceError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: Text('No Data Available'));
          }
        },
      ),
      floatingActionButton: _multiSelectMode
          ? FloatingActionButton(
              onPressed: _onFabPressed,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(LucideIcons.plus, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
