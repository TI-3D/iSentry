import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';
import 'package:isentry/presentation/widgets/appBar/appbar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DetectionLogPage extends StatelessWidget {
  const DetectionLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DetectionBloc>().add(DetectionDetail());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detection Log',
        onLeadingPressed: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<DetectionBloc, DetectionState>(
        builder: (context, state) {
          if (state is DetectionLoading) {
            return const CircularProgressIndicator();
          } else if (state is DetectionFailure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state is DetailDetectionLoaded) {
            final allDetails = [
              ...state.recognizedDetails,
              ...state.unrecognizedDetails,
            ];
            // Mengurutkan berdasarkan timestamp terbaru
            allDetails.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            return Center(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: allDetails.length,
                itemBuilder: (context, index) {
                  final detail = allDetails[index];
                  final formattedDate =
                      DateFormat("d MMMM yyyy").format(detail.timestamp);
                  return Padding(
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
                                detail.identityName ?? 'Anomali',
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
                                    formattedDate,
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
                  );
                },
              ),
            );
          }
          return const Center(child: Text("No data found"));
        },
      ),
    );
  }
}
