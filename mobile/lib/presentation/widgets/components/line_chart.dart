import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';

class LineChartDashboard extends StatelessWidget {
  const LineChartDashboard({super.key});

  @override
  Widget build(BuildContext context) {
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
                  interval: 5,
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
                  interval: 2,
                  getTitlesWidget: (value, meta) {
                    final timeLabels = {
                      0: '08.00',
                      2: '10.00',
                      4: '12.00',
                      6: '14.00',
                      8: '16.00',
                      10: '18.00',
                      12: '20.00',
                    };
                    return Text(
                      timeLabels[value.toInt()] ?? '',
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
            maxX: 12,
            minY: 0,
            maxY: 20,
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 20),
                  FlSpot(2, 12),
                  FlSpot(4, 15),
                  FlSpot(6, 8),
                  FlSpot(8, 17),
                  FlSpot(10, 5),
                  FlSpot(12, 10),
                ],
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
}
