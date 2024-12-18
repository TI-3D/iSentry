import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_bloc.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_event.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_state.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DetailPage extends StatefulWidget {
  final String name;
  final int id;

  const DetailPage({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  State<DetailPage> createState() => _DetailsState();
}

class _DetailsState extends State<DetailPage> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    context
        .read<DetectionBloc>()
        .add(DetectionByIdentity(id: widget.id.toString()));
    // context.read<IdentityBloc>().add(GetIdentityById(id: widget.id.toString()));
  }

  void _toggleSwitch(bool value, BuildContext context) {
    context.read<IdentityBloc>().add(
          UpdateKey(
            id: widget.id.toString(),
            key: value,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
      ),
      body: BlocConsumer<IdentityBloc, IdentityState>(
        listener: (context, state) {
          if (state is IdentityFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          } else if (state is KeyUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Identity updated successfully!')),
            );
            context
                .read<IdentityBloc>()
                .add(GetIdentityById(id: widget.id.toString()));
          }
        },
        builder: (context, stateIdentity) {
          return BlocBuilder<DetectionBloc, DetectionState>(
            builder: (context, stateDetection) {
              if (stateDetection is DetectionLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (stateDetection is DetectionFailure) {
                return Center(
                    child: Text('Error: ${stateDetection.errorMessage}'));
              } else if (stateDetection is ByIdentityLoaded) {
                final sortedDetection = List.from(stateDetection.detection)
                  ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
                final identities =
                    sortedDetection.isNotEmpty ? sortedDetection[0] : null;
                final lastActivity = identities != null
                    ? DateFormat("E").format(identities.timestamp)
                    : '';

                if (stateIdentity is IdentityLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (stateIdentity is IdentityFailure) {
                  return Center(
                      child: Text('Error: ${stateIdentity.errorMessage}'));
                } else if (stateIdentity is IdentityLoaded) {
                  bool isSwitched = stateIdentity.identities.key;
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    "http://$ipAddress${stateIdentity.identities.pictureSinglePath}",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(LucideIcons.userCircle2,
                                          size: 35);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "Last Activity: $lastActivity day",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Door Lock",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    _toggleSwitch(value, context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "History:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sortedDetection.length > 10
                              ? 10
                              : sortedDetection.length,
                          itemBuilder: (context, index) {
                            final identities = sortedDetection[index];
                            final formattedDate =
                                DateFormat("d MMMM yyyy, HH:mm")
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
                                        (sortedDetection.length > 10
                                                ? 10
                                                : sortedDetection.length) -
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
                                    const SizedBox(height: 7),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
              }
              return const Center(child: Text("No Data Found"));
            },
          );
        },
      ),
    );
  }
}
