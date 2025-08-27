import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/admin_user_item.dart';

class AdminUsersTable extends StatefulWidget {
  const AdminUsersTable({super.key});

  @override
  State<AdminUsersTable> createState() => _AdminUsersTableState();
}

class _AdminUsersTableState extends State<AdminUsersTable> {
  final settingsController = SettingsController.instance;

  var columnsArray = ["Name", "Email", "Actions"];

  @override
  void initState() {
    settingsController.getAdminUsers();

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
              0: FlexColumnWidth(), // Email column
              1: FlexColumnWidth(), // Name column
              2: FlexColumnWidth(), // Actions column
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

          Obx((){
            if(settingsController.isLoading.value){
              return const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (settingsController.error.isNotEmpty) {
              return Center(
                child: Text(
                  'Error: ${settingsController.error.value}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (settingsController.adminUsers.isEmpty) {
              return const Center(child: Text("No admin users found"));
            }

            return Column(
              children: settingsController.adminUsers.map((e) {
                var isLastItem =
                    settingsController.adminUsers.last.id == e.id;
                return AdminUserItem(
                  item: e,
                  isLastItem: isLastItem,
                  settingsController: settingsController,
                );
              }).toList(),
            );
          })

        ],
      ),
    );
  }
}
