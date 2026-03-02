import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_metrics.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/presentation/controllers/time_summary_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/presentation/widgets/export_csv_btn.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/presentation/widgets/export_pdf_btn.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/presentation/widgets/summary_card.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/presentation/widgets/trends_chart.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

// assumes you already have these:
// - TimeSummaryController (from earlier)
// - TimeSummaryPreset
// - DateRangeX
// - TimeSummaryTrendsChart (you can keep static spots for now or wire later)
// - SummaryCard
// - ExportCsvButton / ExportPdfButton
// - displayWidth(context)

class TimeSummaryPage extends StatefulWidget {
  const TimeSummaryPage({super.key});

  @override
  State<TimeSummaryPage> createState() => _TimeSummaryPageState();
}

class _TimeSummaryPageState extends State<TimeSummaryPage> {
  final timeSummaryCtrl = TimeSummaryController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timeSummaryCtrl.fetchSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  SizedBox(height: 40, width: 180, child: ExportCsvButton()),
                  SizedBox(width: 12),
                  SizedBox(height: 40, width: 180, child: ExportPdfButton()),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Filter Row (dynamic)
          _buildFilterRow(context),

          const SizedBox(height: 24),

          // KPI section (dynamic)
          Obx(() {
            if (timeSummaryCtrl.isLoading.value && timeSummaryCtrl.kpis.value == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (timeSummaryCtrl.error.value.isNotEmpty) {
              return ErrorBox(
                message: timeSummaryCtrl.error.value,
                onRetry: timeSummaryCtrl.fetchSummary,
              );
            }

            final k = timeSummaryCtrl.kpis.value;
            if (k == null) {
              return const EmptyBox(message: 'No data found for this range.');
            }

            return Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    label: 'Total Student Hours',
                    value: '${k.totalStudentHoursFloat.toStringAsFixed(1)} hrs',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    label: 'Total Tutor Hours',
                    value: '${k.totalTutorHoursFloat.toStringAsFixed(1)} hrs',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    label: 'Student Sessions',
                    value: '${k.studentSessions} sessions',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    label: 'Tutor Sign-ins',
                    value: '${k.tutorSignIns} sign-ins',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    label: 'Total Sign-ins',
                    value: '${k.totalSignIns} sign-ins',
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 32),

          // Middle Section (Trends & Top Tutors)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildTrendsCard()),
              const SizedBox(width: 32),
              Expanded(flex: 1, child: buildTopTutorsCard()),
            ],
          ),

          const SizedBox(height: 32),

          // Detailed Table
          buildDataTable(context),


        ],
      ),
    );
  }

  // -------------------------
  // FILTER ROW (dynamic)
  // -------------------------
  Widget _buildFilterRow(BuildContext context) {
    return Obx(() {
      final active = timeSummaryCtrl.preset.value;
      final rangeText = _formatRange(currentRangePreview());

      return Row(
        children: [
          _buildFilterTab(
            'Last 7 days',
            isActive: active == TimeSummaryPreset.last7Days,
            onTap: () => timeSummaryCtrl.setPreset(TimeSummaryPreset.last7Days),
          ),
          const SizedBox(width: 8),
          _buildFilterTab(
            'Last 30 days',
            isActive: active == TimeSummaryPreset.last30Days,
            onTap: () => timeSummaryCtrl.setPreset(TimeSummaryPreset.last30Days),
          ),
          const SizedBox(width: 8),
          _buildFilterTab(
            'Last 1 year',
            isActive: active == TimeSummaryPreset.last1Year,
            onTap: () => timeSummaryCtrl.setPreset(TimeSummaryPreset.last1Year),
          ),
          const SizedBox(width: 16),

          // Custom date picker button
          InkWell(
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 3),
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(
                  start: currentRangePreview().start,
                  end: currentRangePreview().endInclusive,
                ),
              );

              if (picked != null) {
                await timeSummaryCtrl.setCustomRange(start: picked.start, end: picked.end);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(rangeText),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Optional toggle: include ongoing sessions
          Row(
            children: [
              Obx(() => Switch(
                value: timeSummaryCtrl.includeOngoing.value,
                onChanged: (v) => timeSummaryCtrl.toggleIncludeOngoing(v),
              )),
              const SizedBox(width: 6),
              const Text('Include ongoing', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildFilterTab(
      String label, {
        required bool isActive,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.purple.shade50 : Colors.white,
          border: Border.all(
            color: isActive ? Colors.purple : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.purple : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // -------------------------
  // TRENDS CARD
  // -------------------------
  Widget _buildTrendsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Trends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Obx(() => Text(
                _formatRange(currentRangePreview()),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )),
            ],
          ),
          const SizedBox(height: 16),

          // Legend
          SizedBox(
            height: 20,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  LegendItem(color: Colors.purple, label: 'Students'),
                  SizedBox(width: 16),
                  LegendItem(color: Colors.blueAccent, label: 'Tutors'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Chart
          const TimeSummaryTrendsChart(),
        ],
      ),
    );
  }

  // -------------------------
  // TOP TUTORS CARD (placeholder for now)
  // If you wire TutorHoursRollup later, replace with Obx + list.
  // -------------------------
  Widget buildTopTutorsCard() {
    final ctrl = TimeSummaryController.instance;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Tutors by Hours',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Obx(() => Text(
            _formatRange(ctrl.currentRange),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          )),
          const SizedBox(height: 16),

          Obx(() {
            if (ctrl.isLoading.value && ctrl.tutorRollUps.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (ctrl.error.value.isNotEmpty && ctrl.tutorRollUps.isEmpty) {
              return Text(
                'Error: ${ctrl.error.value}',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              );
            }

            if (ctrl.tutorRollUps.isEmpty) {
              return const Text(
                'No tutor activity found for this range.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              );
            }

            // show top 5
            final top = ctrl.tutorRollUps.take(5).toList();

            return Column(
              children: [

                ...top
                .map(
                (t) => buildTopTutorRow(
              t.tutorName ?? '—',
              '${t.hours.toStringAsFixed(1)} hrs',
              '${t.signIns}',
            ),
            )
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget buildTopTutorRow(String name, String hours, String sessionsOrSignins) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Text(hours, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(sessionsOrSignins, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
  // -------------------------
  // TABLE (placeholder for now)
  // -------------------------
  Widget buildDataTable(BuildContext context) {
    final ctrl = TimeSummaryController.instance;

    return Container(
      width: displayWidth(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Obx(() {
        if (ctrl.isLoading.value && ctrl.tutorRollUps.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (ctrl.error.value.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error: ${ctrl.error.value}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (ctrl.tutorRollUps.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text("No tutor data available")),
          );
        }

        return DataTable(
          columns: const [
            DataColumn(label: Text('Tutor Name')),
            DataColumn(label: Text('Total Hours')),
            DataColumn(label: Text('Sign-ins')),
            DataColumn(label: Text('Avg Duration')),
            DataColumn(label: Text('Last Active')),
            DataColumn(label: Text('Action')),
          ],
          rows: ctrl.tutorRollUps.map((tutor) {
            return DataRow(
              cells: [
                DataCell(Text(tutor.tutorName ?? '—')),
                DataCell(Text('${tutor.hours.toStringAsFixed(1)} hrs')),
                DataCell(Text('${tutor.signIns}')),
                DataCell(Text(formatDuration(tutor.totalHours))),
                DataCell(Text(formatDate(tutor.lastActive))),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to tutor detail page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF514D66),
                    ),
                    child: const Text(
                      'View details',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      }),
    );
  }
  DataRow buildDataRow(
      String name,
      String hours,
      String signs,
      String avg,
      String last,
      ) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(Text(hours)),
        DataCell(Text(signs)),
        DataCell(Text(avg)),
        DataCell(Text(last)),
        DataCell(
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF514D66),
            ),
            child: const Text(
              'View details',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------
  // Range formatting helpers
  // -------------------------
  DateRangeX currentRangePreview() {
    switch (timeSummaryCtrl.preset.value) {
      case TimeSummaryPreset.last7Days:
        return DateRangeX.last7Days();
      case TimeSummaryPreset.last30Days:
        return DateRangeX.last30Days();
      case TimeSummaryPreset.last1Year:
        return DateRangeX.last1Year();
      case TimeSummaryPreset.custom:
        final s = timeSummaryCtrl.customStart.value;
        final e = timeSummaryCtrl.customEnd.value;
        if (s == null || e == null) return DateRangeX.last30Days();
        final start = DateTime(s.year, s.month, s.day);
        final end = DateTime(e.year, e.month, e.day, 23, 59, 59);
        return DateRangeX(start: start, endInclusive: end);
    }
  }

  String _formatRange(DateRangeX r) {
    final fmt = DateFormat('MMM d, yyyy');
    return '${fmt.format(r.start)} - ${fmt.format(r.endInclusive)}';
  }
}

// -------------------------
// Small UI helpers
// -------------------------

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.red))),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class EmptyBox extends StatelessWidget {
  final String message;
  const EmptyBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.inbox_outlined, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}