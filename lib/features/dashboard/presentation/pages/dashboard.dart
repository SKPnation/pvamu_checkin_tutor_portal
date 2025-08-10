import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/fonts.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/add_course_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/add_tutor_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/assign_tutor_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/presentation/widgets/student_logs_table.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final dashboardController = DashboardController.instance;
  final coursesController = CoursesController.instance;
  final tutorsController = TutorsController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: AddCourseButton(coursesController: coursesController),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: AddTutorButton(tutorsController: tutorsController),
                  ),
                ),
                SizedBox(width: 16),

                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: AssignTutorButton(
                      coursesController: coursesController,
                      tutorsController: tutorsController,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),

            CustomText(text: "Student Logs", size: AppFonts.baseSize),

            Container(height: 2, width: 100, color: Colors.blue),

            SizedBox(height: 24),

            CustomText(
              text: "Student Check-In/Check-Out",
              size: 22,
              weight: FontWeight.w500,
            ),
            SizedBox(height: 8),

            StudentLogsTable(),
          ],
        ),
      ),
    );
  }
}
