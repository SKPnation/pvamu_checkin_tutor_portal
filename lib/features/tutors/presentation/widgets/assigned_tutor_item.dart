import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/assigned_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class AssignedTutorItem extends StatelessWidget {
  AssignedTutorItem({
    super.key,
    required this.item,
    required this.isLastItem,
    required this.tutorsController,
  });

  final AssignedModel item;
  final bool isLastItem;

  final actionKey = GlobalKey();
  final viewKey = GlobalKey();

  final TutorsController tutorsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FlexColumnWidth(), // Name column
            1: FlexColumnWidth(), // Course(s)
            2: FlexColumnWidth(), // Status
            // 3: FlexColumnWidth(), // Actions
          },
          children: [
            TableRow(
              children: [
                Center(child: CustomText(text: item.tutor?.name, size: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: "${item.courses?.length} courses",),
                    SizedBox(width: 4),
                    GestureDetector(
                      key: viewKey,
                      onTap: () => displayCoursesPopUp(context, item.courses, viewKey, item.tutor!.id!),
                      child: Container(width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.gold,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15), // softer, semi-transparent shadow
                                  blurRadius: 6, // smoothness
                                  spreadRadius: 1, // subtle spread
                                  offset: const Offset(0, 3), // shadow position (x, y)
                                ),
                              ]
                          ),
                          child: Center(child: CustomText(text: "view", color: AppColors.white, weight: FontWeight.bold,),)),
                    )
                  ],
                ),
                
                GestureDetector(
                  key: actionKey,
                  onTap: () => displayActionPopUp(context, tutorsController, actionKey, item.tutor!.id!),
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
      String tutorId,
      ) {
    final RenderBox button = key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    // Position of the button relative to the overlay
    final Offset topLeft =
    button.localToGlobal(Offset.zero, ancestor: overlay);
    final Offset bottomRight =
    button.localToGlobal(button.size.bottomRight(Offset.zero),
        ancestor: overlay);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(topLeft, bottomRight),
      Offset.zero & overlay.size, // container = overlay bounds
    );

    return showMenu<String>(
      context: context,
      color: Colors.white,
      position: position,
      items: const [
        PopupMenuItem<String>(value: 'un-assign', child: Text('Un-assign')),
        PopupMenuItem<String>(value: 'details', child: Text('View Details')),
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
    final RenderBox button = key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    // Position of the button relative to the overlay
    final Offset topLeft =
    button.localToGlobal(Offset.zero, ancestor: overlay);
    final Offset bottomRight =
    button.localToGlobal(button.size.bottomRight(Offset.zero),
        ancestor: overlay);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(topLeft, bottomRight),
      Offset.zero & overlay.size, // container = overlay bounds
    );

    return showMenu<String>(
      context: context,
      color: Colors.white,
      position: position,
      items: courses!.map((e)=>PopupMenuItem<String>(value: e.id!, onTap: null, child: CustomText(text: '${e.category} - ${e.name}'),)).toList(),
    );
  }
}
