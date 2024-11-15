import 'package:flutter/material.dart';
import 'package:isentry/presentation/home/pages/unrecognized/bottom_sheets/add_data.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UnrecognizedPage extends StatefulWidget {
  const UnrecognizedPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UnrecognizedPageState createState() => _UnrecognizedPageState();
}

class _UnrecognizedPageState extends State<UnrecognizedPage> {
  final List<bool> _isSelected = List.generate(6, (_) => false);

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

  void _toggleSelection(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
    });
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
            texts: ['Today', 'Week', 'Month', 'Year'], selectedIndex: 0
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
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
                          image: const DecorationImage(
                            image: AssetImage('assets/images/nani.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 8,
                              left: 8,
                              child: GestureDetector(
                                onTap: () => _toggleSelection(index),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Anomali#0${index + 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.calendarDays,
                        size: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '25 June 2024, 08:00',
                        style: TextStyle(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDataBottomSheet(context),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
