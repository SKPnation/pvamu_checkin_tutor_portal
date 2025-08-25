import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/app_routes.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/data/repos/auth_repo_impl.dart';

class AuthMiddleware extends GetMiddleware {
  final authRepo = AuthRepoImpl();

  @override
  RouteSettings? redirect(String? route) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    return isLoggedIn ? null : const RouteSettings(name: Routes.authRoute);
  }
}
