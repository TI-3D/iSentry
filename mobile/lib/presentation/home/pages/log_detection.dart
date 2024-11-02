import 'package:flutter/material.dart';
import 'package:isentry/presentation/home/pages/detail_log_detection.dart';
import 'package:isentry/presentation/widgets/appBar/appbar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LogDetectionPage extends StatelessWidget {
  const LogDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> logData = [
      {'name': 'Olivia Martin', 'date': '25 June 2024, 08:00'},
      {'name': 'William Smith', 'date': '25 June 2024, 08:00'},
      {'name': 'Bob Johnson', 'date': '25 June 2024, 08:00'},
      {'name': 'Alice Smith', 'date': '25 June 2024, 08:00'},
      {'name': 'Emily Davis', 'date': '25 June 2024, 08:00'},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Log Detection',
        onLeadingPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: logData.length,
          itemBuilder: (context, index) {
            final item = logData[index];
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => LogDetailWidget(
                    name: item['name']!,
                    lastActivity: item['date']!,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.userCircle2,
                      color: Colors.black,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['name']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                LucideIcons.calendarDays,
                                color: Colors.black,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                item['date']!,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  letterSpacing: 1.0,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
