import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/data/repos/auth_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/pages/site_layout.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();

  RxBool isPasswordVisible = false.obs;

  AuthRepoImpl authRepo = AuthRepoImpl();

  Future<void> login() async {
    try {
      final userCredential = await authRepo.login(
        email: emailTEC.text,
        password: passwordTEC.text,
      );

      print("Logged in as: ${userCredential.user!.uid}");

      Get.to(SiteLayout());
    } catch (e) {
      CustomSnackBar.errorSnackBar("Login failed: $e");
    }
  }

  Future logOut() async => await authRepo.logout();

  Future checkIfUserExistsInDB() async{
    authRepo.checkIfUserExistsInDB(email: emailTEC.text);
  }
}
