import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/app_routes.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/fonts.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/add_course_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/add_tutor_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/assign_tutor_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/widgets/view_type_item_widget.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/presentation/widgets/student_logs_table.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/presentation/widgets/tutor_logs_table.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final dashboardController = DashboardController.instance;
  final coursesController = CoursesController.instance;
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
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: AddCourseButton(
                      coursesController: coursesController,
                      from: AppStrings.dashboardTitle.toLowerCase(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: AddTutorButton(
                      tutorsController: tutorsController,
                      from: AppStrings.tutorsTitle.toLowerCase(),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: AssignTutorButton(
                      coursesController: coursesController,
                      tutorsController: tutorsController,
                      from: AppStrings.assignedTutorsTitle.toLowerCase(),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),

            Row(
              children:
                  dashboardController.views
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: ViewTypeItemWidget(
                            type: e,
                            onTap: () {
                              final views = dashboardController.views;
                              final index = views.indexOf(e);
                              dashboardController.viewIndex.value = index;
                            },
                            dashboardController: dashboardController,
                          ),
                        ),
                      )
                      .toList(),
            ),

            SizedBox(height: 24),

            Obx(
              () => CustomText(
                text:
                    "${dashboardController.viewIndex.value == 0 ? "Student" : "Tutor"} Check-In/Check-Out",
                size: 22,
                weight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),

            Obx(
              () =>
                  dashboardController.viewIndex.value == 0
                      ? StudentLogsTable()
                      : TutorLogsTable(),
            ),
          ],
        ),
      ),
    );
  }
}
