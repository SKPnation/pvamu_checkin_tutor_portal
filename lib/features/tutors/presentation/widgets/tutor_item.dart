import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/assign_tutor_dialog.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/delete_dialog.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/edit_dialog.dart';

class TutorItem extends StatelessWidget {
  TutorItem({
    super.key,
    required this.item,
    required this.isLastItem,
    required this.coursesController,
    required this.tutorsController,
  });

  final Tutor item;
  final bool isLastItem;

  final GlobalKey actionKey = GlobalKey();

  final CoursesController coursesController;
  final TutorsController tutorsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(), // First name column
            1: FlexColumnWidth(), // Last name column
            2: FlexColumnWidth(), // Email column
            3: FlexColumnWidth(), // Time In column//
            4: FlexColumnWidth(), // Time In column//
            5: FlexColumnWidth(), // Duration column//
            6: FlexColumnWidth(), // Status column//
            7: FlexColumnWidth(), // Date Added column//
            8: FlexColumnWidth(), // Actions column// // Status c
          },
          children: [
            TableRow(
              children: [
                Center(
                  child: CustomText(text: item.fName.toString(), size: 12),
                ),
                Center(
                  child: CustomText(text: item.lName.toString(), size: 12),
                ),
                Center(
                  child: CustomText(text: item.email.toString(), size: 12),
                ),
                Center(
                  child: CustomText(text: formatTime(item.timeIn), size: 12),
                ),

                //time out
                Center(
                  child: CustomText(
                    text:
                        item.timeOut == null ? "--" : formatTime(item.timeOut),
                    size: 12,
                  ),
                ),

                //duration
                Center(
                  child: CustomText(
                    text:
                        item.timeOut == null
                            ? "--"
                            : formatDuration(
                              item.timeOut!.difference(item.timeIn!),
                            ),
                    size: 12,
                  ),
                ),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      item.blockedAt != null
                          ? Flexible(
                            child: CustomText(
                              text: "Deactivated",
                              color: AppColors.red,
                            ),
                          )
                          : item.timeIn == null && item.timeOut == null
                          ? SizedBox()
                          : Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color:
                                  item.timeOut == null
                                      ? Colors.green
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                      const SizedBox(width: 4),
                      CustomText(
                        text:
                            item.blockedAt != null
                                ? ""
                                : (item.timeIn == null && item.timeOut == null)
                                ? "--"
                                : (item.timeIn != null && item.timeOut == null)
                                ? "Signed In"
                                : "Signed Out",
                        size: 12,
                      ),
                    ],
                  ),
                ),

                Center(
                  child: CustomText(
                    text: formatDate(item.createdAt!),
                    size: 12,
                  ),
                ),
                GestureDetector(
                  key: actionKey, // Assign the key here
                  onTap:
                      () => displayActionPopUp(
                        context,
                        TutorsController.instance,
                        actionKey,
                        item,
                      ),
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
        if (!isLastItem) const Divider(),
        if (isLastItem) SizedBox(height: 8),
      ],
    );
  }

  displayActionPopUp(
    BuildContext context,
    TutorsController tutorsController,
    GlobalKey key,
    Tutor tutor,
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
          onTap: () {
            Get.dialog(
              AssignTutorDialog(
                coursesController: coursesController,
                tutorsController: tutorsController,
                tutorId: tutor.id,
              ),
            );
          },
          value: 'assign',
          child: const Text('Assign'),
        ),
        PopupMenuItem(
          onTap: () {
            Get.dialog(
              EditDialog(
                tutorsController: tutorsController,
                tutorId: tutor.id!,
              ),
            );
          },
          value: 'edit',
          child: const Text('Edit'),
        ),
        PopupMenuItem(
          onTap: () async {
            if (tutor.blockedAt == null) {
              await tutorsController.deactivate(tutorId: tutor.id!);
            } else {
              await tutorsController.activate(tutorId: tutor.id!);
            }
          },
          value: tutor.blockedAt == null ? 'block' : "Unblock",
          child: Text(tutor.blockedAt == null ? 'block' : "Unblock"),
        ),
        PopupMenuItem(
          onTap: () async {
            Get.dialog(
              DeleteDialog(
                tutorsController: tutorsController,
                tutorId: tutor.id!,
              ),
            );
          },
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );
  }
}
