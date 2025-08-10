import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
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
              3: FlexColumnWidth(), // Time In column
              4: FlexColumnWidth(), // Time Out column
              5: FlexColumnWidth(), // Duration column
              6: FlexColumnWidth(), // Status column
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
                        child: CircularProgressIndicator(
                          color: Color(0xFF43A95D),
                        ),
                      ));
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

                var students = snapshot.data as List<Student>;

                // Sort by date in descending order
                students.sort((a, b) => b.timeIn!.compareTo(a.timeIn!));

                return Column(
                  children: students.map((e) {
                   var isLastItem = students[students.length - 1].id == e.id;


                    return StudentLogItem(item: e, isLastItem: isLastItem,);
                  }).toList(),
                );
              }),
        ],
      )
    );
  }
}
