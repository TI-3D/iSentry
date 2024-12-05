import 'package:flutter/material.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:isentry/presentation/home/pages/profile/account_settings.dart';
import 'package:isentry/presentation/widgets/components/line_chart.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardResidentPage extends StatelessWidget {
  const DashboardResidentPage({super.key});

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
                    color: Color(0xFFc8cad1)),
              ),
              Text(
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
                  context,
                  const AccountSettingsPage(
                    userId: '1',
                  ));
            },
            icon: const Icon(
              (LucideIcons.userCircle2),
              size: 40,
            ),
          ),
        ],
      ),
    );

    Widget activity = Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
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
                  onPressed: () {},
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
    );

    return Column(
      children: [
        Expanded(
            flex: 12,
            child: Container(
              child: dashboard,
            )),
        const Expanded(
            flex: 6,
            child: Center(
              child: MySort(
                texts: ['Week', 'Month', 'Year'],
                leftPadding: 35,
                rightPadding: 35,
              ),
            )),
        const Expanded(
            flex: 23,
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 30),
              child: AspectRatio(
                aspectRatio: 3,
                child: LineChartDashboard(),
              ),
            )),
        Expanded(
            flex: 35,
            child: Container(
              child: activity,
            )),
      ],
    );
  }
}
