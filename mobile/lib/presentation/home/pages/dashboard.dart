import 'package:flutter/material.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';
import 'package:isentry/presentation/home/pages/profile/account_settings.dart';
import 'package:isentry/presentation/home/pages/detection_log.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardPage extends StatelessWidget {
  final Function toRecognized;
  final Function toUnrecognized;
  const DashboardPage({super.key, required this.toRecognized, required this.toUnrecognized});

  @override
  Widget build(BuildContext context) {
    Widget dashboard = Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only(left: 35, right: 35, top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hello!",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: Color(0xFFc8cad1)
                ),
              ),
              Text(
                "My Dashboard",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  fontSize: 16
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () {
              AppNavigator.push(context, const AccountSettingsPage());
            },
            icon: const Icon(
              (LucideIcons.userCircle2),
              size: 40,
            )
          )
        ],
      ),
    );

    Widget faces = Container(
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
                padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          "50",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w700,
                            height: 0.9
                          ),
                        ),
                        Text(
                          " Faces",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1
                          ),
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
                padding: const EdgeInsets.only(left: 13, right: 13, top: 10, bottom: 10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          "22",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w700,
                            height: 0.9
                          ),
                        ),
                        Text(
                          " Faces",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1
                          ),
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

    Widget activity = InkWell(
      onTap: () {
        AppNavigator.push(context, const DetectionLogPage());
      },
      child: Container(
        color: AppColors.primary,
        padding:
            const EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
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
                      AppNavigator.push(context, const DetectionLogPage());
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
              const Row(
                children: [
                  Icon(
                    (LucideIcons.userCircle2),
                    color: Colors.white,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olivia Martin",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.calendarDays,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "25 June 2024, 08:00",
                            style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 1.0,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const Row(
                children: [
                  Icon(
                    (LucideIcons.userCircle2),
                    color: Colors.white,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olivia Martin",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.calendarDays,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "25 June 2024, 08:00",
                            style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 1.0,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const Row(
                children: [
                  Icon(
                    (LucideIcons.userCircle2),
                    color: Colors.white,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olivia Martin",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.calendarDays,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "25 June 2024, 08:00",
                            style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 1.0,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const Row(
                children: [
                  Icon(
                    (LucideIcons.userCircle2),
                    color: Colors.white,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olivia Martin",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.calendarDays,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "25 June 2024, 08:00",
                            style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 1.0,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );

    return Column(
      children: [
        Expanded(
          flex: 12,
          child: dashboard,
        ),
        Expanded(
          flex: 11,
          child: faces,
        ),
        Expanded(
          flex: 26,
          child: Column(
            children: [
              const MySort(
                texts: ['Today', 'Week', 'Month', 'Year'],
                selectedIndex: 0,
              ),
              Expanded(
                child: Container(
                  color: AppColors.primary,
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 27,
          child: activity,
        ),
      ],
    );
  }
}
