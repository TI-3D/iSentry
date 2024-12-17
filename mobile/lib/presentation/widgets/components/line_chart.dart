import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:isentry/data/models/detection_detail_model.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';

class LineChartDashboard extends StatefulWidget {
  final int filter;
  const LineChartDashboard({super.key, required this.filter});

  @override
  State<LineChartDashboard> createState() => _LineChartDashboardState();
}

class _LineChartDashboardState extends State<LineChartDashboard> {
  // int filter = 0;

  @override
  void initState() {
    context.read<DetectionBloc>().add(DetectionDetail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

          final now = DateTime.now();
          DateTime startOfPeriod, endOfPeriod;

          // Memfilter data berdasarkan filter
          List<DetectionDetailModel> filteredDetails;
          switch (widget.filter) {
            case 0:
              // Filter untuk hari ini
              startOfPeriod = DateTime(
                  now.year, now.month, now.day); // Mulai dari 00:00 hari ini
              endOfPeriod = DateTime(now.year, now.month, now.day, 23, 59,
                  59); // Sampai 23:59:59 hari ini
              break;
            case 1:
              // Filter untuk minggu ini (Senin sampai Minggu)
              startOfPeriod = now.subtract(
                  Duration(days: now.weekday - 1)); // Mulai dari Senin
              endOfPeriod =
                  now.add(Duration(days: 7 - now.weekday)); // Sampai Minggu
              break;
            case 2:
              // Filter untuk bulan ini (Minggu 1 - Minggu 4)
              startOfPeriod = DateTime(
                  now.year, now.month, 1); // Mulai dari tanggal 1 bulan ini
              endOfPeriod = DateTime(
                  now.year, now.month + 1, 0); // Sampai akhir bulan ini
              break;
            case 3:
              // Filter untuk tahun ini
              startOfPeriod = DateTime(now.year, 1, 1); // Mulai dari 1 Januari
              endOfPeriod = DateTime(now.year + 1, 1, 1)
                  .subtract(Duration(days: 1)); // Sampai 31 Desember
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
            final timeIndex = widget.filter == 0
                ? _convertTimeToIndexForToday(detail.timestamp.hour)
                : _convertTimeToIndexForYear(detail.timestamp.month);

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
              padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        interval: widget.filter == 0
                            ? 4
                            : widget.filter == 1
                                ? 10
                                : (widget.filter == 2 ? 20 : 40),
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
                        interval: widget.filter == 0
                            ? 2
                            : (widget.filter == 1
                                ? 2
                                : (widget.filter == 2 ? 4 : 1)),
                        getTitlesWidget: (value, meta) {
                          // Menampilkan label waktu yang sesuai dengan filter
                          Map<int, String> timeLabels;
                          switch (widget.filter) {
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
                                0: 'Senin',
                                2: 'Selasa',
                                4: 'Rabu',
                                6: 'Kamis',
                                8: 'Jumat',
                                10: 'Sabtu',
                                12: 'Minggu',
                              };
                              break;
                            case 2:
                              timeLabels = {
                                0: 'Minggu 1',
                                4: 'Minggu 2',
                                8: 'Minggu 3',
                                12: 'Minggu 4',
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
                  maxX: widget.filter == 0
                      ? 14
                      : (widget.filter == 1
                          ? 12
                          : (widget.filter == 2 ? 12 : 12)),
                  minY: 0,
                  maxY: widget.filter == 0
                      ? 20
                      : (widget.filter == 1
                          ? 50
                          : (widget.filter == 2 ? 100 : 200)),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.chart,
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
    );
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

  int _convertTimeToIndexForYear(int month) {
    return month - 1;
  }
}
