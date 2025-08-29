import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/pages/site_layout.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();

  RxBool isPasswordVisible = false.obs;

  AuthRepoImpl authRepo = AuthRepoImpl();

  Future<bool> login() async {
   var success = false;

   // Initialize MenController
   Get.put(MenController());

    try {
      final userCredential = await authRepo.login(
        email: emailTEC.text,
        password: passwordTEC.text,
      );

      if(userCredential.user != null){
        success = true;
      }
    } catch (e) {
      success = false;
      CustomSnackBar.errorSnackBar("Login failed: $e");
    }

    return success;
  }

  Future logOut() async => await authRepo.logout();

  bool isPvamuEmail(String email) => email.contains('@pvamu.edu');
}
