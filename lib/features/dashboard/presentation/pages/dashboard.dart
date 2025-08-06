import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/add_course_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/add_tutor_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/assign_tutor_button.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final dashboardController = DashboardController.instance;
  final coursesController = CoursesController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
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
                  child: AddTutorButton(coursesController: coursesController),
                ),
              ),
              SizedBox(width: 16),

              Expanded(
                child: SizedBox(
                  height: 60,
                  child: AssignTutorButton(
                    coursesController: coursesController,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 40),

          CustomText(text: "Student Logs"),

        ],
      ),
    );
  }
}
