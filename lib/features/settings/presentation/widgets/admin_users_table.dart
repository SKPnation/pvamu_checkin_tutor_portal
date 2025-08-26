import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/local_navigator.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/admin_user_item.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/admin_user_controller.dart';

class AdminUsersTable extends StatefulWidget {
  const AdminUsersTable({super.key});

  @override
  State<AdminUsersTable> createState() => _AdminUsersTableState();
}

class _AdminUsersTableState extends State<AdminUsersTable> {
  final adminUserController = AdminUserController.instance;

  var columnsArray = ["Name", "Email"];

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
              0: FlexColumnWidth(), // Email column
              1: FlexColumnWidth(), // Name column
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
            future: settingsController.getAdminUsers(),
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

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No admin users found"));
              }

              var adminUsers = snapshot.data!;

              return Column(
                children:
                    adminUsers.map((e) {
                      var isLastItem =
                          adminUsers[adminUsers.length - 1].id == e.id;
                      return AdminUserItem(
                        item: e,
                        isLastItem: isLastItem,
                        settingsController: settingsController,
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
