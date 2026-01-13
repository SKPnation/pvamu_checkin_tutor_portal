import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/presentation/controllers/student_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/presentation/widgets/students_table.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {


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

              // Assigned Tutors Table
              StudentsTable()
            ],
          ),
        ));
  }
}
