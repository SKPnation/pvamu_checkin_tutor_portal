import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/add_tutor_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/tutors_table.dart';

class TutorsPage extends StatelessWidget {
  TutorsPage({super.key});

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
              SizedBox(
                height: 60,
                width: 200,
                child: AddTutorButton(tutorsController: tutorsController)
              ),

              SizedBox(height: 40),

              TutorsTable(),
            ],
          ),
        ));
  }
}
