import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/presentation/controllers/time_summary_controller.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeSummaryTrendsChart extends StatelessWidget {
  const TimeSummaryTrendsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = TimeSummaryController.instance;

    return Obx(() {
      final students = ctrl.studentSpots.toList();
      final tutors = ctrl.tutorSpots.toList();
      final range = ctrl.currentRange; // add getter below

      // 1) Empty state
      if (students.isEmpty && tutors.isEmpty) {
        return const SizedBox(
          height: 240,
          child: Center(child: Text("No chart data for this range")),
        );
      }

      final isMonthly = range.endInclusive.difference(range.start).inDays > 35;

      // 2) Compute bounds
      final maxX = isMonthly
          ? 12.0
          : (range.endInclusive
          .difference(DateTime(range.start.year, range.start.month, range.start.day))
          .inDays)
          .toDouble();

      final allY = <double>[
        ...students.map((e) => e.y),
        ...tutors.map((e) => e.y),
      ];
      final maxY = (allY.isEmpty ? 1.0 : allY.reduce((a, b) => a > b ? a : b)) * 1.2;

      return AspectRatio(
        aspectRatio: 2,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: maxX,
            minY: 0,
            maxY: maxY,
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) {
                  return Colors.grey.withOpacity(.1); // popup color
                },
                  tooltipBorderRadius: BorderRadius.circular(10),
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.1),
                strokeWidth: 1,
              ),
            ),

            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: isMonthly ? 1 : _smartInterval(maxX),
                  getTitlesWidget: (value, meta) {
                    if (isMonthly) {
                      // value = 1..12 (months)
                      final m = value.toInt();
                      if (m < 1 || m > 12) return const SizedBox.shrink();
                      final label = DateFormat('MMM').format(DateTime(2026, m, 1));
                      return Text(label, style: _labelStyle);
                    } else {
                      // value = 0..N (day index from range.start)
                      final idx = value.toInt();
                      final date = DateTime(range.start.year, range.start.month, range.start.day)
                          .add(Duration(days: idx));
                      return Text(DateFormat('MMM d').format(date), style: _labelStyle);
                    }
                  },
                ),
              ),
            ),

            borderData: FlBorderData(show: false),

            lineBarsData: [
              LineChartBarData(
                spots: students,
                isCurved: true,
                color: Colors.purple,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: true, color: Colors.purple.withOpacity(0.1)),
              ),
              LineChartBarData(
                spots: tutors,
                isCurved: true,
                color: Colors.blueAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.1)),
              ),
            ],
          ),
        ),
      );
    });
  }

  static TextStyle get _labelStyle => const TextStyle(color: Colors.grey, fontSize: 10);

  static double _smartInterval(double maxX) {
    // keeps labels readable
    if (maxX <= 7) return 1;
    if (maxX <= 14) return 2;
    if (maxX <= 31) return 5;
    return 10;
  }
}