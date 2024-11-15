import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Details extends StatelessWidget {
  final String name;
  final String lastActivity;

  const Details({
    super.key,
    required this.name,
    required this.lastActivity,
  });

  @override
  Widget build(BuildContext context) {
    // Sample history data for this detail view
    final List<String> history = [
      "25 June 2024, 08:00",
      "24 June 2024, 14:30",
      "24 June 2024, 08:15",
      "23 June 2024, 17:45",
      "23 June 2024, 08:00",
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xfff1f4f9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title of the log detail view
          const Center(
            child: Text(
              "Details",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // User details row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.userCircle2,
                color: Colors.black,
                size: 40,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Last Activity $lastActivity",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // History section title
          const Text(
            "History :",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          // History list with bullet points and connecting lines
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.black,
                        size: 6,
                      ),
                      if (index < history.length - 1)
                        Container(
                          width: 2,
                          height: 25,
                          color: Colors.black,
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.calendarDays,
                        color: Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        history[index],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
