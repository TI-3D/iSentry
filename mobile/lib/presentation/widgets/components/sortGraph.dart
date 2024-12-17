import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:isentry/data/models/detection_detail_model.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';

class Sortgraph extends StatefulWidget {
  final List<String> texts;
  final double leftPadding;
  final double rightPadding;
  const Sortgraph(
      {super.key,
      required this.texts,
      required this.leftPadding,
      required this.rightPadding});

  @override
  State<Sortgraph> createState() => _SortgraphState();
}

class _SortgraphState extends State<Sortgraph> {
  int selectedIndex = 0;

  @override
  void initState() {
    context.read<DetectionBloc>().add(DetectionDetail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetectionBloc, DetectionState>(
      listener: (context, state) {
        if (state is DetectionInitial) {
          context.read<DetectionBloc>().add(DetectionDetail());
        }
      },
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 241, 244, 249),
            padding: EdgeInsets.only(
              left: widget.leftPadding,
              right: widget.rightPadding,
              top: 14,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFe7e8eb),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(widget.texts.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 25,
                      width: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: index == selectedIndex
                            ? Colors.black
                            : const Color(0xFFe7e8eb),
                      ),
                      child: Center(
                        child: Text(
                          widget.texts[index],
                          style: TextStyle(
                            color: index == selectedIndex
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<DetectionBloc, DetectionState>(
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

                  final now = DateTime.now();
                  DateTime startOfPeriod, endOfPeriod;

                  // Memfilter data berdasarkan filter
                  List<DetectionDetailModel> filteredDetails;
                  switch (selectedIndex) {
                    case 0:
                      // Filter untuk hari ini
                      startOfPeriod = DateTime(now.year, now.month, now.day);
                      endOfPeriod =
                          DateTime(now.year, now.month, now.day, 23, 59, 59);
                      break;
                    case 1:
                      // Filter untuk minggu ini (Senin sampai Minggu)
                      startOfPeriod =
                          now.subtract(Duration(days: now.weekday - 1));
                      endOfPeriod = startOfPeriod.add(const Duration(
                          days: 6, hours: 23, minutes: 59, seconds: 59));
                      break;
                    case 2:
                      // Filter untuk bulan ini (Minggu 1 - Minggu 4)
                      startOfPeriod = DateTime(now.year, now.month, 1);
                      endOfPeriod =
                          DateTime(now.year, now.month + 1, 0, 23, 59, 59);
                      break;
                    case 3:
                      // Filter untuk tahun ini
                      startOfPeriod = DateTime(now.year, 1, 1);
                      endOfPeriod = DateTime(now.year + 1, 1, 1)
                          .subtract(Duration(days: 1));
                      break;
                    default:
                      startOfPeriod = endOfPeriod = now;
                  }

                  filteredDetails = allDetails.where((detail) {
                    final timestamp = detail.timestamp;
                    return timestamp.isAfter(startOfPeriod) &&
                        timestamp.isBefore(endOfPeriod);
                  }).toList();

                  // Mengecek hasil filter
                  print('Data terfilter: ${filteredDetails.length} deteksi');

                  // Membuat grafik dengan data terfilter
                  final timeCountMap = <int, int>{};

                  // Menghitung jumlah deteksi berdasarkan waktu
                  for (var detail in filteredDetails) {
                    final timeIndex = selectedIndex == 0
                        ? _convertTimeToIndexForToday(detail.timestamp.hour)
                        : selectedIndex == 1
                            ? _convertTimeToIndexForWeek(
                                detail.timestamp.weekday)
                            : selectedIndex == 2
                                ? _convertTimeToIndexForMonth(
                                    (detail.timestamp.day - 1) ~/ 7 + 1)
                                : _convertTimeToIndexForYear(
                                    detail.timestamp.month);

                    if (timeCountMap.containsKey(timeIndex)) {
                      timeCountMap[timeIndex] = timeCountMap[timeIndex]! + 1;
                    } else {
                      timeCountMap[timeIndex] = 1;
                    }
                  }

                  // Mengonversi timeCountMap menjadi List<FlSpot>
                  final spots = timeCountMap.entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                  }).toList();

                  print('Total spots: ${spots.length}');

                  return AspectRatio(
                    aspectRatio: 1.7,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(
                            show: false, // Grid tidak ditampilkan
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: selectedIndex == 0
                                    ? 4
                                    : selectedIndex == 1
                                        ? 10
                                        : (selectedIndex == 2 ? 20 : 40),
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: selectedIndex == 0
                                    ? 2
                                    : (selectedIndex == 1
                                        ? 2
                                        : (selectedIndex == 2 ? 4 : 1)),
                                getTitlesWidget: (value, meta) {
                                  // Menampilkan label waktu yang sesuai dengan filter
                                  Map<int, String> timeLabels;
                                  switch (selectedIndex) {
                                    case 0:
                                      timeLabels = {
                                        0: '03.00',
                                        2: '06.00',
                                        4: '09.00',
                                        6: '12.00',
                                        8: '15.00',
                                        10: '18.00',
                                        12: '21.00',
                                        14: '23.00',
                                      };
                                      break;
                                    case 1:
                                      timeLabels = {
                                        0: 'Mon',
                                        2: 'Tue',
                                        4: 'Wed',
                                        6: 'Thu',
                                        8: 'Fri',
                                        10: 'Sat',
                                        12: 'Sun',
                                      };
                                      break;
                                    case 2:
                                      timeLabels = {
                                        0: 'Week 1',
                                        4: 'Week 2',
                                        8: 'Week 3',
                                        12: 'Week 4',
                                      };
                                      break;
                                    case 3:
                                      timeLabels = {
                                        0: 'Jan',
                                        1: 'Feb',
                                        2: 'Mar',
                                        3: 'Apr',
                                        4: 'May',
                                        5: 'Jun',
                                        6: 'Jul',
                                        7: 'Aug',
                                        8: 'Sep',
                                        9: 'Oct',
                                        10: 'Nov',
                                        11: 'Dec',
                                      };
                                      break;
                                    default:
                                      timeLabels = {};
                                  }

                                  return Text(
                                    timeLabels[value.toInt()] ?? '',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false, // Hapus border di sekitar grafik
                          ),
                          minX: 0,
                          maxX: selectedIndex == 0
                              ? 14
                              : (selectedIndex == 1
                                  ? 12
                                  : (selectedIndex == 2 ? 12 : 11)),
                          minY: 0,
                          maxY: selectedIndex == 0
                              ? 20
                              : (selectedIndex == 1
                                  ? 50
                                  : (selectedIndex == 2 ? 100 : 200)),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              gradient: const RadialGradient(colors: [
                                Colors.white,
                                AppColors.chart,
                              ]),
                              barWidth: 4,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.chart.withOpacity(0.3),
                                    AppColors.primary.withOpacity(0.2),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              dotData: const FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const Center(child: Text("No Data Found"));
              },
            ),
          )
        ],
      ),
    );
  }
}

int _convertTimeToIndexForToday(int hour) {
  final timeMap = {
    3: 0,
    6: 2,
    9: 4,
    12: 6,
    15: 8,
    18: 10,
    21: 12,
    23: 14,
  };

  // Cari interval waktu terdekat
  int closestTime = timeMap.keys
      .reduce((a, b) => (hour - a).abs() < (hour - b).abs() ? a : b);

  return timeMap[closestTime] ?? 0;
}

int _convertTimeToIndexForWeek(int weekday) {
  final timeMap = {
    1: 0,
    2: 2,
    3: 4,
    4: 6,
    5: 8,
    6: 10,
    7: 12,
  };

  return timeMap[weekday] ?? 0;
}

int _convertTimeToIndexForMonth(int weekOfMonth) {
  final timeMap = {
    1: 0,
    2: 4,
    3: 8,
    4: 12,
  };

  return timeMap[weekOfMonth] ?? 0;
}

int _convertTimeToIndexForYear(int month) {
  return month - 1;
}
