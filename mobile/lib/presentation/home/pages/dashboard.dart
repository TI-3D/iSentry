import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';
import 'package:isentry/presentation/home/bloc/user/user_bloc.dart';
import 'package:isentry/presentation/home/bloc/user/user_event.dart';
import 'package:isentry/presentation/home/bloc/user/user_state.dart';
import 'package:isentry/presentation/widgets/components/line_chart.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';
import 'package:isentry/presentation/home/pages/profile/account_settings.dart';
import 'package:isentry/presentation/home/pages/detection_log.dart';
import 'package:isentry/services/notification_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardPage extends StatelessWidget {
  final int userId;
  final Function toRecognized;
  final Function toUnrecognized;
  const DashboardPage({
    super.key,
    required this.toRecognized,
    required this.toUnrecognized,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(GetUserById(id: '$userId'));

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial || state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          return Column(
            children: [
              Expanded(
                flex: 12,
                child: Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hallo ${state.user.name}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: Color(0xFFc8cad1)),
                          ),
                          const Text(
                            "My Dashboard",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                fontSize: 16),
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          AppNavigator.push(
                              context, AccountSettingsPage(userId: userId));
                        },
                        icon: const Icon(
                          (LucideIcons.userCircle2),
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: Faces(
                  toRecognized: toRecognized,
                  toUnrecognized: toUnrecognized,
                ),
              ),
              const Expanded(
                flex: 27,
                child: Column(
                  children: [
                    MySort(
                      texts: ['Today', 'Week', 'Month', 'Year'],
                      leftPadding: 35,
                      rightPadding: 35,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, right: 30),
                        child: AspectRatio(
                          aspectRatio: 3,
                          child: LineChartDashboard(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 27,
                //child: Activity(),
                child: Column(
                  children: [
                    const Activity(),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Callback untuk memanggil notifikasi
                          showNotification(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Send Notification",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const Center(
          child: Text("Unexpected state!"),
        );
      },
    );
  }

  // Fungsi untuk memanggil notifikasi
  void showNotification(BuildContext context) async {
    await NotificationService.showNotification("kocak", "geming");
    print("Notification button pressed!"); // Tambahkan log untuk memverifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Notifikasi berhasil dikirim!"),
      ),
    );
  }

}

class Faces extends StatelessWidget {
  final Function toRecognized;
  final Function toUnrecognized;
  const Faces({
    super.key,
    required this.toRecognized,
    required this.toUnrecognized,
  });

  @override
  Widget build(BuildContext context) {
    context.read<DetectionBloc>().add(DetectionDetail());
    return BlocBuilder<DetectionBloc, DetectionState>(
      builder: (context, state) {
        if (state is DetectionLoading) {
          return const CircularProgressIndicator();
        } else if (state is DetectionFailure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is DetailDetectionLoaded) {
          return Container(
            color: AppColors.primary,
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      toRecognized();
                    },
                    child: Container(
                      height: 90,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                (LucideIcons.userCheck2),
                                size: 20,
                                color: Colors.white,
                              ),
                              Text(
                                " Recognized",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${state.recognizedDetails.length}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w700,
                                    height: 0.9),
                              ),
                              const Text(
                                " Faces",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      toUnrecognized();
                    },
                    child: Container(
                      height: 90,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.only(
                          left: 13, right: 13, top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                (LucideIcons.userX2),
                                size: 20,
                                color: Colors.white,
                              ),
                              Text(
                                " Unrecognized",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${state.unrecognizedDetails.length}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w700,
                                    height: 0.9),
                              ),
                              const Text(
                                " Faces",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text("No data found"));
      },
    );
  }
}

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DetectionBloc>().add(DetectionDetail());
    return BlocBuilder<DetectionBloc, DetectionState>(
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
          // Mengambil 4 entri teratas
          final topDetails = allDetails.take(4).toList();
          return InkWell(
            onTap: () {
              AppNavigator.push(context, const DetectionLogPage());
            },
            child: Container(
              color: AppColors.primary,
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 10, bottom: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 0, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          " Detection Log",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            AppNavigator.push(
                                context, const DetectionLogPage());
                          },
                          icon: const Icon(
                            LucideIcons.calendarClock,
                            color: Colors.white,
                            size: 25,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    for (var detail in topDetails) ...[
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.userCircle2,
                            color: Colors.white,
                            size: 30,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.identityName ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.calendarDays,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    DateFormat("d MMMM yyyy, HH:mm")
                                        .format(detail.timestamp),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      letterSpacing: 1.0,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: Text("No data found"));
      },
    );
  }
}
