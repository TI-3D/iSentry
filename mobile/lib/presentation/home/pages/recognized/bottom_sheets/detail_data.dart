import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Details extends StatelessWidget {
  final String name;
  final int id;

  const Details({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    context.read<DetectionBloc>().add(DetectionByIdentity(id: id.toString()));
    return BlocBuilder<DetectionBloc, DetectionState>(
      builder: (context, state) {
        if (state is DetectionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DetectionFailure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is ByIdentityLoaded) {
          final sortedDetection = List.from(state.detection);
          sortedDetection.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          final identities =
              sortedDetection.isNotEmpty ? sortedDetection[0] : null;
          final lastActivity = identities != null
              ? DateFormat("E").format(identities.timestamp)
              : '';
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
                          "Last Activity ${lastActivity}day",
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
                // History list with bullet points and connecting lines

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      state.detection.length > 10 ? 10 : state.detection.length,
                  itemBuilder: (context, index) {
                    final sortedDetection = List.from(state.detection);
                    sortedDetection
                        .sort((a, b) => b.timestamp.compareTo(a.timestamp));
                    final identities = sortedDetection[index];
                    final formattedDate = DateFormat("d MMMM yyyy, HH:mm")
                        .format(identities.timestamp);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            if (index == 0) const SizedBox(height: 10),
                            if (index > 0)
                              Container(
                                width: 2,
                                height: 10,
                                color: Colors.black,
                              ),
                            const SizedBox(height: 5),
                            const Icon(
                              Icons.circle,
                              color: Colors.black,
                              size: 6,
                            ),
                            const SizedBox(height: 5),
                            if (index <
                                (state.detection.length > 10
                                        ? 10
                                        : state.detection.length) -
                                    1)
                              Container(
                                width: 2,
                                height: 10,
                                color: Colors.black,
                              ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            const SizedBox(
                              height: 7,
                            ),
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
                                  formattedDate,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
        return const Center(child: Text("No Data Found"));
      },
    );
  }
}
