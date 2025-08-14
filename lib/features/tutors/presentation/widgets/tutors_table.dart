import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/tutor_item.dart';

class TutorsTable extends StatefulWidget {
  const TutorsTable({super.key});

  @override
  State<TutorsTable> createState() => _TutorsTableState();
}

class _TutorsTableState extends State<TutorsTable> {
  final tutorsController = TutorsController.instance;
  final courseController = CoursesController.instance;

  var columnsArray = [
    "Name",
    "Email",
    "Time In",
    "Time Out",
    "Duration",
    'Status',
    "Date Added",
    "Actions",
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
              2: FlexColumnWidth(), // Time In column//
              3: FlexColumnWidth(), // Time In column//
              4: FlexColumnWidth(), // Duration column//
              5: FlexColumnWidth(), // Status column//
              6: FlexColumnWidth(), // Date Added column//
              7: FlexColumnWidth(), // Actions column// // Status column
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
            future: tutorsController.getTutors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: AppColors.purple),
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

              var tutors = snapshot.data as List<Tutor>;

              tutors.sort((a, b) {
                if (a.timeIn != null && b.timeIn != null) {
                  return b.timeIn!.compareTo(a.timeIn!);
                } else {
                  return b.createdAt!.compareTo(a.createdAt!);
                }
              });

              return Column(
                children:
                    tutors.map((e) {
                      var isLastItem = tutors[tutors.length - 1].id == e.id;

                      return TutorItem(
                        item: e,
                        isLastItem: isLastItem,
                        coursesController: courseController,
                        tutorsController: tutorsController,
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
