import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/presentation/controllers/student_controller.dart';

class StudentLogsTable extends StatefulWidget {
  const StudentLogsTable({super.key});

  @override
  State<StudentLogsTable> createState() => _StudentLogsTableState();
}

class _StudentLogsTableState extends State<StudentLogsTable> {
  final studentsController = StudentsController.instance;

  var columnsArray = [
    "Student ID",
    "Student Name",
    "Student Email",
    "Goal",
    "Course",
    "Tutor",
    "Time In",
    "Time Out"
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
              0: FlexColumnWidth(), // Student ID column
              1: FlexColumnWidth(), // Student Name column
              2: FlexColumnWidth(), // Student Email column
              3: FlexColumnWidth(), // Goal column
              4: FlexColumnWidth(), // Course column
              5: FlexColumnWidth(), // Tutor column
              6: FlexColumnWidth(), // Time In column
              7: FlexColumnWidth(), // Time Out column
            },
            children: [
              TableRow(
                children:
                columnsArray
                    .map(
                      (e) => Center(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
              future: studentsController.getStudentLogs(),
              builder: (context, snapshot){
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

                var students = snapshot.data as List<StudentLoginHistory>;
                students.sort((a,b) {
                  final A = a.timeIn ?? DateTime.fromMillisecondsSinceEpoch(0);
                  final B = b.timeIn ?? DateTime.fromMillisecondsSinceEpoch(0);
                  return B.compareTo(A);
                });

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
                                Center(child: CustomText(text: "${item.studentId}", size: 12)),
                                //email
                                Center(child: CustomText(text: item.studentName ?? '', size: 12)),
                                //email
                                Center(child: CustomText(text: item.studentEmail ?? '', size: 12)),

                                //Goal
                                Center(child: CustomText(text: item.goal ?? '', size: 12)),

                                //course name
                                Center(
                                  child: CustomText(text: item.course?.name ?? "--", size: 12),
                                ),

                                //tutor name
                                Center(
                                  child: CustomText(
                                    text: "${item.tutor?.fName ?? "--"} ${item.tutor?.lName ?? "--"}" ,
                                    size: 12,
                                  ),
                                ),
                                //time in
                                Center(child: CustomText(
                                  text: item.timeIn == null
                                      ? "--"
                                      : "${formatTime(item.timeIn)}\n${formatDate(item.timeIn)}",
                                  textAlign: TextAlign.center,
                                  size: 12,
                                )),

                                //time out
                                Center(child: CustomText(
                                  text: item.timeOut == null
                                      ? "--"
                                      : "${formatTime(item.timeOut)}\n${formatDate(item.timeOut)}",
                                  textAlign: TextAlign.center,
                                  size: 12,
                                )),

                              ],
                            ),
                          ],
                        ),
                        if (!isLastItem) const Divider(),
                        if(isLastItem) SizedBox(height: 8),

                      ],
                    );
                  }).toList(),
                );

              }
          )
        ],
      ),
    );
  }
}
