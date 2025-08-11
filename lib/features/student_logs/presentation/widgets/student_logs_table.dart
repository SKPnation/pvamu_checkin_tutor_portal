import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/presentation/widgets/student_log_item.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/presentation/controllers/student_logs_controller.dart';

class StudentLogsTable extends StatefulWidget {
  const StudentLogsTable({super.key});

  @override
  State<StudentLogsTable> createState() => _StudentLogsTableState();
}

class _StudentLogsTableState extends State<StudentLogsTable> {
  final studentsController = StudentLogsController.instance;
  var columnsArray = [
    "Name",
    "Email",
    "Course",
    "Tutor",
    "Time In",
    "Time Out",
    "Duration",
    'Status',
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
          Table(
            columnWidths: const {
              0: FlexColumnWidth(), // Name column
              1: FlexColumnWidth(), // Email column
              2: FlexColumnWidth(), // Course column
              3: FlexColumnWidth(), // Tutor column
              4: FlexColumnWidth(), // Time In column
              5: FlexColumnWidth(), // Time Out column
              6: FlexColumnWidth(), // Duration column
              7: FlexColumnWidth(), // Status column
            },
            children: [
              TableRow(
                children:
                columnsArray
                    .map(
                      (e) => Center(
                    child: CustomText(
                      text: e.toUpperCase(),
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                  ),
                )
                    .toList(),
              ),
            ],
          ),

          SizedBox(height: 11.5),
          FutureBuilder(
            future: studentsController.getStudentLogs(),
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
                print(snapshot.error);
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

              var students = snapshot.data as List<Student>;
              students.sort((a, b) => b.timeIn!.compareTo(a.timeIn!));



              return Column(
                children: students.asMap().entries.map((entry) {
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
                          5: FlexColumnWidth(),
                          6: FlexColumnWidth(),
                          7: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              //name
                              Center(child: CustomText(text: item.name ?? '', size: 12)),
                              //email
                              Center(child: CustomText(text: item.email ?? '', size: 12)),

                              //course name
                              Center(
                                child: CustomText(text: item.course?.name ?? '', size: 12),
                              ),

                              //tutor name
                              Center(
                                child: CustomText(
                                  text: item.tutor?.name ?? 'tutor',
                                  size: 12,
                                ),
                              ),
                              //time in
                              Center(child: CustomText(text: formatTime(item.timeIn), size: 12)),

                              //time out
                              Center(
                                child: CustomText(
                                  text:
                                  item.timeOut == null ? "--" : formatTime(item.timeOut),
                                  size: 12,
                                ),
                              ),

                              //duration
                              Center(child: CustomText(
                                text: item.timeOut == null
                                    ? "--"
                                    : formatDuration(item.timeOut!.difference(item.timeIn!)),
                                size: 12,
                              )),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                        color: item.timeOut == null ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      text: item.timeOut == null ? "Signed In" : "Signed Out",
                                      size: 12,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      if (!isLastItem) const Divider(),
                    ],
                  );
                }).toList(),
              );
            },
          )
        ],
      )
    );
  }
}
