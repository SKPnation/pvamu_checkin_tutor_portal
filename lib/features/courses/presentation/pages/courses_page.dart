import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/widgets/courses_table.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/add_course_button.dart';

class CoursesPage extends StatelessWidget {
  CoursesPage({super.key});

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
          SizedBox(
            height: 60,
            width: 200,
            child: AddCourseButton(coursesController: coursesController),
          ),

          SizedBox(height: 40),

          //Only this should scroll but it isn't scrolling
          Expanded(child: SingleChildScrollView(child: CoursesTable())),
        ],
      ),
    );
  }
}
