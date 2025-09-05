import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class CourseItem extends StatelessWidget {
  CourseItem({super.key, required this.item, required this.isLastItem});

  final Course item;
  final bool isLastItem;

  final GlobalKey actionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(), //Course
            1: FlexColumnWidth(), //Category
            2: FlexColumnWidth(), //Status
            3: FlexColumnWidth(), //Action
          },
          children: [
            TableRow(
              children: [
                Center(child: CustomText(text: item.code.toString(), size: 12)),
                Center(
                  child: CustomText(text: item.name.toString(), size: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color:
                            item.status!.toLowerCase() == "published"
                                ? Colors.green
                                : AppColors.grey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(width: 4),
                    CustomText(text: item.status, size: 12),
                  ],
                ),
                Center(
                  child: GestureDetector(
                    key: actionKey, // Assign the key here
                    onTap:
                        () => displayActionPopUp(
                          context,
                          CoursesController.instance,
                          actionKey,
                          item.id!,
                        ),
                    child: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ],
        ),

        if (!isLastItem) Divider(),
        if (isLastItem) SizedBox(height: 8),
      ],
    );
  }

  displayActionPopUp(
    BuildContext context,
    CoursesController coursesController,
    GlobalKey key,
    String courseId,
  ) {
    // Get the RenderBox and its position
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Show the menu at the calculated position
    return showMenu(
      color: Colors.white, // Set your preferred color
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx, // X-coordinate of the GestureDetector
        offset.dy + size.height, // Y-coordinate + height of the item
        offset.dx + size.width, // Width of the GestureDetector
        0, // No margin at the bottom
      ),
      items: [
        PopupMenuItem(
          onTap: () async {
            await coursesController.archiveCourse(courseId: courseId);
          },
          value: 'archive',
          child: const Text('Archive'),
        ),
        PopupMenuItem(
          onTap: () async {
            await coursesController.delete(courseId: courseId);
            coursesController.getCourses();
          },
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );
  }
}
