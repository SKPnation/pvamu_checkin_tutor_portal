import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/assign_tutor_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/assigned_tutors_table.dart';

class AssignedTutorsPage extends StatefulWidget {
  AssignedTutorsPage({super.key});

  @override
  State<AssignedTutorsPage> createState() => _AssignedTutorsPageState();
}

class _AssignedTutorsPageState extends State<AssignedTutorsPage> {
  final tutorsController = TutorsController.instance;

  final coursesController = CoursesController.instance;

  @override
  void initState() {
    super.initState();

    tutorsController.fetchAssignedTutors();
  }


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
              SizedBox(
                  height: 60,
                  width: 200,
                  child: AssignTutorButton(tutorsController: tutorsController, coursesController: coursesController, from: AppStrings.assignedTutorsTitle,)
              ),

              SizedBox(height: 40),

              // Assigned Tutors Table
              AssignedTutorsTable()
            ],
          ),
        ));
  }
}
