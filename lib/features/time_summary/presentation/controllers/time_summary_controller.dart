import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_metrics.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/repos/time_summary_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/domain/repos/time_summary_repo.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

enum TimeSummaryPreset { last7Days, last30Days, last1Year, custom }

class TimeSummaryController extends GetxController {
  static TimeSummaryController get instance => Get.find();

  final TimeSummaryRepo repo = TimeSummaryRepoImpl();

  // ---------------------------
  // State
  // ---------------------------
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final Rx<TimeSummaryKpis?> kpis = Rx<TimeSummaryKpis?>(null);
  final RxList<FlSpot> studentSpots = <FlSpot>[].obs;
  final RxList<FlSpot> tutorSpots = <FlSpot>[].obs;

  final Rx<TimeSummaryPreset> preset = TimeSummaryPreset.last30Days.obs;
  final Rxn<DateTime> customStart = Rxn<DateTime>();
  final Rxn<DateTime> customEnd = Rxn<DateTime>();
  final RxBool includeOngoing = false.obs;
  final RxList<TutorHoursRollup> tutorRollUps = <TutorHoursRollup>[].obs;

  // ---------------------------
  // Public API (for the page)
  // ---------------------------

  /// Call this in initState (use postFrameCallback if needed)
  Future<void> fetchSummary() async {
    error.value = '';
    isLoading.value = true;

    try {
      final range = _resolveRange();
      final res = await repo.getTimeSummary(
        range: range,
        includeOngoing: includeOngoing.value,
      );

      // KPIs
      kpis.value = res.kpis;

      // Chart
      studentSpots.assignAll(res.studentSpots);
      tutorSpots.assignAll(res.tutorSpots);

      // BUILD ROLLUPS HERE
      tutorRollUps.assignAll(res.topTutors);

      // Top tutors (if included in response)
      if (res.topTutors != null) {
        tutorRollUps.assignAll(res.topTutors!);
      } else {
        // If you don't return topTutors, keep existing list (or clear)
        tutorRollUps.clear();
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }

    debugPrint(
      'studentSpots: ${studentSpots.length}, tutorSpots: ${tutorSpots.length}',
    );
  }

  DateRangeX get currentRange => _resolveRange();

  /// Switch preset: 7 days / 30 days / 1 year (auto refresh)
  Future<void> setPreset(TimeSummaryPreset newPreset) async {
    preset.value = newPreset;
    if (newPreset != TimeSummaryPreset.custom) {
      customStart.value = null;
      customEnd.value = null;
    }
    await fetchSummary();
  }

  /// Set custom range and refresh
  Future<void> setCustomRange({
    required DateTime start,
    required DateTime end,
  }) async {
    preset.value = TimeSummaryPreset.custom;
    customStart.value = start;
    customEnd.value = end;
    await fetchSummary();
  }

  /// Toggle counting ongoing sessions and refresh
  Future<void> toggleIncludeOngoing(bool v) async {
    includeOngoing.value = v;
    await fetchSummary();
  }

  // ---------------------------
  // Convenience getters (for UI)
  // ---------------------------
  int get studentSessions => kpis.value?.studentSessions ?? 0;

  int get tutorSignIns => kpis.value?.tutorSignIns ?? 0;

  int get totalSignIns => kpis.value?.totalSignIns ?? 0;

  double get totalStudentHours => kpis.value?.totalStudentHoursFloat ?? 0.0;

  double get totalTutorHours => kpis.value?.totalTutorHoursFloat ?? 0.0;

  // ---------------------------
  // Internals
  // ---------------------------
  DateRangeX _resolveRange() {
    switch (preset.value) {
      case TimeSummaryPreset.last7Days:
        return DateRangeX.last7Days();
      case TimeSummaryPreset.last30Days:
        return DateRangeX.last30Days();
      case TimeSummaryPreset.last1Year:
        return DateRangeX.last1Year();
      case TimeSummaryPreset.custom:
        final s = customStart.value;
        final e = customEnd.value;
        if (s == null || e == null) return DateRangeX.last30Days();
        return DateRangeX(
          start: DateTime(s.year, s.month, s.day),
          endInclusive: DateTime(e.year, e.month, e.day, 23, 59, 59),
        );
    }
  }
}
