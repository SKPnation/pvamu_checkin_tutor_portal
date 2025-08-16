import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/assigned_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/assigned_tutor_item.dart';

class AssignedTutorsTable extends StatefulWidget {
  const AssignedTutorsTable({super.key});

  @override
  State<AssignedTutorsTable> createState() => _AssignedTutorsTableState();
}

class _AssignedTutorsTableState extends State<AssignedTutorsTable> {
  final tutorsController = TutorsController.instance;

  var columnsArray = ["Assigned Tutor", "Course(s)", "Actions"];

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
              0: FlexColumnWidth(), // Name column
              1: FlexColumnWidth(), // Course(s) column
              2: FlexColumnWidth(), // Status column//
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
          SizedBox(height: 4),
          const Divider(),
          FutureBuilder(
            future: tutorsController.getAssignedTutors(),
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

              var assignedTutors = snapshot.data as List<AssignedModel>;

              assignedTutors.sort(
                (a, b) => b.createdAt!.compareTo(a.createdAt!),
              );

              return Column(
                children:
                assignedTutors.map((e) {
                  var isLastItem = assignedTutors[assignedTutors.length - 1].id == e.id;

                  return AssignedTutorItem(
                    item: e,
                    isLastItem: isLastItem,
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
