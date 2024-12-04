import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/presentation/home/bloc/faces/face_bloc.dart';
import 'package:isentry/presentation/home/bloc/faces/face_event.dart';
import 'package:isentry/presentation/home/bloc/faces/face_state.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'bottom_sheets/add_data.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';

class UnrecognizedPage extends StatelessWidget {
  const UnrecognizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FaceBloc()..add(LoadUnrecognizedFaces()), // Inisialisasi FaceBloc
      child: const _UnrecognizedPageView(),
    );
  }
}

class _UnrecognizedPageView extends StatefulWidget {
  const _UnrecognizedPageView();

  @override
  _UnrecognizedPageViewState createState() => _UnrecognizedPageViewState();
}

class _UnrecognizedPageViewState extends State<_UnrecognizedPageView> {
  final List<bool> _isSelected =
      []; // Akan diisi sesuai jumlah wajah dari state

  void _showAddDataBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddDataUnreg(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff1f4f9),
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: MySort(
            texts: ['Today', 'Week', 'Month', 'Year'],
            leftPadding: 25,
            rightPadding: 25,
          ),
        ),
      ),
      body: BlocBuilder<FaceBloc, FaceState>(
        builder: (context, state) {
          if (state is FaceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FaceLoaded) {
            // Update jumlah _isSelected sesuai jumlah data
            if (_isSelected.isEmpty) {
              _isSelected
                  .addAll(List.generate(state.faces.length, (_) => false));
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSelected[index] = !_isSelected[index];
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
                              '${face.createdAt}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDataBottomSheet(context),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
