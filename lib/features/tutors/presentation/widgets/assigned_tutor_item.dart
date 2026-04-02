import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/assigned_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/edit_dialog.dart';

class AssignedTutorItem extends StatelessWidget {
  AssignedTutorItem({
    super.key,
    required this.item,
    required this.isLastItem,
    required this.tutorsController,
  });

  final AssignedModel item;
  final bool isLastItem;

  final assignedTutorActionKey = GlobalKey();
  final assignedTutorViewKey = GlobalKey();
  final assignedTutorViewScheduleKey = GlobalKey();

  final TutorsController tutorsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: item.tutor == null
                          ? "--"
                          : "${item.tutor?.fName} ${item.tutor?.lName}",
                      size: 12,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      key: assignedTutorViewScheduleKey,
                      onTap: () => Get.dialog(
                        EditDialog(
                          tutorsController: tutorsController,
                          tutorId: item.tutor!.id!,
                        ),
                      ),
                      child: Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.gold,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          text: "view",
                          color: AppColors.white,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text:
                          "${item.courses?.length} course${item.courses!.length > 1 ? "s" : ""}",
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          key: assignedTutorViewKey,
                          onTap: () => displayCoursesPopUp(
                            context,
                            item.courses,
                            assignedTutorViewKey,
                            item.tutor!.id!,
                          ),
                          child: Container(
                            width: 50,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.gold,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: "view",
                              color: AppColors.white,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      key: assignedTutorActionKey,
                      onTap: () async {
                        displayActionPopUp(
                          context,
                          tutorsController,
                          item.courses,
                          assignedTutorActionKey,
                          item.tutor!.id!,
                        );
                      },
                      child: const Icon(Icons.more_vert),
                    ),
                  ),
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
    List<Course>? courses,
    GlobalKey key,
    String tutorId,
  ) {
    final RenderBox button =
        key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // Position of the button relative to the overlay
    final Offset topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Offset bottomRight = button.localToGlobal(
      button.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(topLeft, bottomRight),
      Offset.zero & overlay.size, // container = overlay bounds
    );

    return showMenu<String>(
      context: context,
      color: Colors.white,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'un-assign',
          child: Text('Un-assign'),
          onTap: () {
            Get.dialog(
              AlertDialog(
                backgroundColor: AppColors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Un-assign"),

                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close),
                      tooltip:
                          "return to ${AppStrings.assignedTutorsTitle} page",
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            courses!.map((e) {
                              var index = courses.indexOf(e);

                              return Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    tutorsController.selectedCourseIndex.value =
                                        index.toString();
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          border: Border.all(
                                            color: AppColors.purple,
                                            width:
                                                1.5, // thickness of the border
                                          ),
                                        ),
                                        child:
                                            tutorsController
                                                        .selectedCourseIndex
                                                        .value ==
                                                    index.toString()
                                                ? Center(
                                                  child: Container(
                                                    height: 5,
                                                    width: 5,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.purple,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            100,
                                                          ),
                                                    ),
                                                  ),
                                                )
                                                : SizedBox.shrink(),
                                      ),
                                      SizedBox(width: 4),
                                      CustomText(text: e.name!),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    SizedBox(height: 12),
                    SizedBox(
                      width: 360,
                      child: CustomButton(
                        onPressed: () async {
                          //un-assign a tutor to a course
                          await tutorsController.unAssignToCourse(
                            courseId:
                                courses![int.parse(
                                      tutorsController
                                          .selectedCourseIndex
                                          .value,
                                    )]
                                    .id!,
                            tutorId: tutorId,
                          );
                        },
                        text: "Un-assign",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        PopupMenuItem<String>(
          onTap: () {
            Get.dialog(
              EditDialog(tutorsController: tutorsController, tutorId: tutorId),
            );
          },
          value: 'details',
          child: Text('View Details'),
        ),
      ],
    ).then((value) {
      // if (value == 'un-assign') tutorsController.unAssignTutor(tutorId);
      // if (value == 'details') tutorsController.viewTutorDetails(tutorId);
    });
  }

  displayCoursesPopUp(
    BuildContext context,
    List<Course>? courses,
    GlobalKey key,
    String tutorId,
  ) {
    final RenderBox button =
        key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // Position of the button relative to the overlay
    final Offset topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Offset bottomRight = button.localToGlobal(
      button.size.bottomRight(Offset.zero),
      ancestor: overlay,
    );

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(topLeft, bottomRight),
      Offset.zero & overlay.size, // container = overlay bounds
    );

    return showMenu<String>(
      context: context,
      color: Colors.white,
      position: position,
      items:
          courses!
              .map(
                (e) => PopupMenuItem<String>(
                  value: e.id!,
                  onTap: null,
                  child: CustomText(text: '${e.name} - ${e.code}'),
                ),
              )
              .toList(),
    );
  }
}
