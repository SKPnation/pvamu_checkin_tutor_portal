import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';

class AssignCourseField extends StatefulWidget {
  const AssignCourseField({
    super.key,
    required this.coursesController,
    this.onChanged,
  });

  final CoursesController coursesController;
  final VoidCallback? onChanged;

  @override
  State<AssignCourseField> createState() => _AssignCourseFieldState();
}

class _AssignCourseFieldState extends State<AssignCourseField> {
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = widget.coursesController.getCourses(); // cache
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // take the dialog's constrained width
      child: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(color: Color(0xFF43A95D)),
              ),
            );
          }

          if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            );
          }

          final courses = snapshot.data ?? <Course>[];
          final selected = widget.coursesController.selectedCourse?.value;
          final selectedId = selected?.id;

          return DropdownButtonFormField<String>(
            isExpanded: true, // prevents internal Row overflow
            value: courses.any((c) => c.id == selectedId) ? selectedId : null,

            // What shows when closed
            selectedItemBuilder: (context) => courses.map((c) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${c.name} - ${c.code}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              );
            }).toList(),

            // Menu items
            items: courses.map((c) {
              return DropdownMenuItem<String>(
                value: c.id,
                child: Text(
                  "${c.name} - ${c.code}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              );
            }).toList(),

            onChanged: (String? value) {
              if (value == null) return;

              final course = courses.firstWhere((c) => c.id == value);
              final rx = widget.coursesController.selectedCourse;
              if (rx == null) {
                widget.coursesController.selectedCourse = Rx<Course>(course);
              } else {
                rx.value = course;
              }

              widget.onChanged?.call();
              setState(() {});
            },

            decoration: InputDecoration(
              hintText: 'Select course',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}
