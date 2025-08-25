import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/widgets/course_item.dart';

class CoursesTable extends StatefulWidget {
  const CoursesTable({super.key});

  @override
  State<CoursesTable> createState() => _CoursesTableState();
}

class _CoursesTableState extends State<CoursesTable> {
  final coursesController = CoursesController.instance;
  var columnsArray = ["Course", "Code", "Category", "Status", "Action"];

  @override
  void initState() {
    coursesController.getCourses();

    super.initState();
  }

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
              0: FlexColumnWidth(), // Course column
              1: FlexColumnWidth(), // Code column
              2: FlexColumnWidth(), // Category column
              3: FlexColumnWidth(), // Status column
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

          Obx(() {
            if (coursesController.isLoading.value) {
              return const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (coursesController.error.isNotEmpty) {
              return Center(
                child: Text(
                  'Error: ${coursesController.error.value}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (coursesController.courses.isEmpty) {
              return const Center(child: Text("No courses found"));
            }

            return Column(
              children: coursesController.courses.map((e) {
                var isLastItem =
                    coursesController.courses.last.id == e.id;
                return CourseItem(item: e, isLastItem: isLastItem);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
