import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class TutorLogsTable extends StatefulWidget {
  const TutorLogsTable({super.key});

  @override
  State<TutorLogsTable> createState() => _TutorLogsTableState();
}

class _TutorLogsTableState extends State<TutorLogsTable> {
  final tutorsController = TutorsController.instance;

  var columnsArray = [
    "Tutor ID",
    "Tutor Name",
    "Tutor Email",
    "Time In",
    "Time Out",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1,
          color: AppColors.grey[300]!.withOpacity(.3),
        ),
      ),

      child: Column(
        children: [
          SizedBox(height: 4),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children:
                    columnsArray
                        .map(
                          (e) => Center(
                            child: Text(
                              e,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),

          SizedBox(height: 4),
          const Divider(),
          FutureBuilder(
            future: tutorsController.getTutorLogs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Color(0xFF43A95D)),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }

              var students = snapshot.data as List<TutorLoginHistory>;
              students.sort((a, b) {
                final A = a.timeIn ?? DateTime.fromMillisecondsSinceEpoch(0);
                final B = b.timeIn ?? DateTime.fromMillisecondsSinceEpoch(0);
                return B.compareTo(A);
              });

              return Column(
                children:
                    students.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isLastItem = index == students.length - 1;

                      return Column(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(),
                              1: FlexColumnWidth(),
                              2: FlexColumnWidth(),
                              3: FlexColumnWidth(),
                              4: FlexColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  //name
                                  Center(
                                    child: CustomText(
                                      text: "${item.tutorId}",
                                      size: 12,
                                    ),
                                  ),
                                  //email
                                  Center(
                                    child: CustomText(
                                      text: item.tutorName ?? '',
                                      size: 12,
                                    ),
                                  ),
                                  //email
                                  Center(
                                    child: CustomText(
                                      text: item.tutorEmail ?? '',
                                      size: 12,
                                    ),
                                  ),

                                  //time in
                                  Center(
                                    child: CustomText(
                                      text:
                                          item.timeIn == null
                                              ? "--"
                                              : "${formatTime(item.timeIn)}\n${formatDate(item.timeIn)}",
                                      textAlign: TextAlign.center,
                                      size: 12,
                                    ),
                                  ),

                                  //time out
                                  Center(
                                    child: CustomText(
                                      text:
                                          item.timeOut == null
                                              ? "--"
                                              : "${formatTime(item.timeOut)}\n${formatDate(item.timeOut)}",
                                      textAlign: TextAlign.center,
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (!isLastItem) const Divider(),
                          if (isLastItem) SizedBox(height: 8),
                        ],
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
