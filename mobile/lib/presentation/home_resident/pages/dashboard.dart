import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';
import 'package:isentry/presentation/home/bloc/user/user_bloc.dart';
import 'package:isentry/presentation/home/bloc/user/user_event.dart';
import 'package:isentry/presentation/home/bloc/user/user_state.dart';
import 'package:isentry/presentation/home/pages/profile/account_settings.dart';
import 'package:isentry/presentation/widgets/components/sortGraphResident.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardResidentPage extends StatefulWidget {
  final String userId;
  const DashboardResidentPage({super.key, required this.userId});

  @override
  State<DashboardResidentPage> createState() => _DashboardResidentPageState();
}

class _DashboardResidentPageState extends State<DashboardResidentPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<DetectionBloc>()
        .add(DetectionByIdentity(id: widget.userId.toString()));
    context.read<UserBloc>().add(GetUserById(id: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is AutoLogout) {
          AppNavigator.push(context, const LoginPage());
        }
      },
      builder: (context, state) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserFailure) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state is UserLoaded) {
              return Column(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      color: AppColors.primary,
                      padding:
                          const EdgeInsets.only(left: 35, right: 35, top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hallo ${state.user.name}",
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
                                  context,
                                  AccountSettingsPage(
                                    userId: widget.userId,
                                  ));
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
                    flex: 29,
                    // child: Text("hallo"),
                    child: SortgraphResident(
                      texts: const ['Today', 'Week', 'Month'],
                      leftPadding: 35,
                      rightPadding: 35,
                      identityId: widget.userId,
                    ),
                  ),
                  Expanded(
                    flex: 35,
                    child: Activity(
                      name: state.user.name,
                      identityId: state.user.identityId,
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text("No Data Founds"));
          },
        );
      },
    );
  }
}

class Activity extends StatelessWidget {
  final int? identityId;
  final String name;
  const Activity({super.key, required this.name, this.identityId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetectionBloc, DetectionState>(
      builder: (context, state) {
        if (state is DetectionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DetectionFailure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is ByIdentityLoaded) {
          final sortedDetection = List.from(state.detection);
          sortedDetection.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return Container(
            color: AppColors.primary,
            padding:
                const EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        " Detection Log",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                  Column(
                    children: sortedDetection.take(6).map((identities) {
                      final formattedDate = DateFormat("d MMMM yyyy, HH:mm")
                          .format(identities.timestamp);
                      return Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                (LucideIcons.userCircle2),
                                color: Colors.white,
                                size: 30,
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
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
                                        formattedDate,
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
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          );
        }
        return const Center(child: Text("No Data Found"));
      },
    );
  }
}
