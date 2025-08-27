import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/settings_routes.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/repos/admin_users_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/domain/entities/add_admin_user_data.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  final firstNameTEC = TextEditingController();
  final lastNameTEC = TextEditingController();
  final emailAddressTEC = TextEditingController();
  final passwordTEC = TextEditingController();

  var activeItem = SettingsRoutes.generalDisplayName.obs;
  final GlobalKey<NavigatorState> settingsNavigatorKey = GlobalKey();

  var hoverItem = "".obs;
  var adminUsers = <AdminUser>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  AdminUserRepoImpl adminUserRepo = AdminUserRepoImpl();

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case SettingsRoutes.generalDisplayName:
        return _customIcon(Icons.public, itemName);
      case SettingsRoutes.securityDisplayName:
        return _customIcon(Icons.security, itemName);
      case SettingsRoutes.teamManagementDisplayName:
        return _customIcon(Icons.people, itemName);
      default:
        return _customIcon(Icons.public, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (itemName == activeItem.value) {
      return Icon(icon, size: 22, color: AppColors.gold);
    }

    return Icon(
      icon,
      color: isHovering(itemName) ? AppColors.gold : AppColors.grey[900],
    );
  }

  Future<dynamic> navigateTo(String routeName) {
    return settingsNavigatorKey.currentState!.pushNamed(routeName);
  }

  goBack() => settingsNavigatorKey.currentState!.pop();

  Future getAdminUsers() async =>
      adminUsers.value = await adminUserRepo.getUsers();

  Future addAdminUser() async {
    await adminUserRepo.addUser(
      AddAdminUserData(
        id: adminUserRepo.adminUserCollection.doc().id,
        email: emailAddressTEC.text,
        password: passwordTEC.text,
        firstName: firstNameTEC.text,
        lastName: lastNameTEC.text,
      ),
    );

    getAdminUsers();
  }

  void generatePassword(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random.secure();
    passwordTEC.text =
        List.generate(
          length,
          (index) => chars[random.nextInt(chars.length)],
        ).join();
  }
}
