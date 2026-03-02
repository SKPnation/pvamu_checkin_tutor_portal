import 'package:fl_chart/fl_chart.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_metrics.dart';

class TimeSummaryResponse {
  final TimeSummaryKpis kpis;
  final List<FlSpot> studentSpots;
  final List<FlSpot> tutorSpots;
  final List<TutorHoursRollup> topTutors;

  const TimeSummaryResponse({
    required this.kpis,
    required this.studentSpots,
    required this.tutorSpots,
    required this.topTutors,
  });
}