import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/repos/tutors_repo_impl.dart';

class TutorsController extends GetxController {
  static TutorsController get instance => Get.find();

  final nameTEC = TextEditingController();
  final emailAddressTEC = TextEditingController();

  TutorsRepoImpl tutorsRepo = TutorsRepoImpl();

  Future addTutor() async => await tutorsRepo.addTutor(
    Tutor(
      id: tutorsRepo.tutorsCollection.doc().id,
      name: nameTEC.text,
      email: emailAddressTEC.text,
      createdAt: DateTime.now(),
    ),
  );
}
