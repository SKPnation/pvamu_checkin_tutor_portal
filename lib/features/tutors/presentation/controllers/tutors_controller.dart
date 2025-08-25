import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/assigned_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/repos/tutors_repo_impl.dart';

class TutorsController extends GetxController {
  static TutorsController get instance => Get.find();

  final nameTEC = TextEditingController();
  final emailAddressTEC = TextEditingController();

  Rx<Tutor>? selectedTutor;

  TutorsRepoImpl tutorsRepo = TutorsRepoImpl();

  var tutors = <Tutor>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  Future addTutor() async {
    await tutorsRepo.addTutor(
      Tutor(
        id: tutorsRepo.tutorsCollection.doc().id,
        name: nameTEC.text,
        email: emailAddressTEC.text,
        createdAt: DateTime.now(),
      ),
    );

    getTutors();
  }

  Future getTutors() async => tutors.value = await tutorsRepo.getTutors();

  Future<List<AssignedModel>> getAssignedTutors() async =>
      await tutorsRepo.getAssignedTutors();

  Future assignToCourse({
    required String courseId,
    required String tutorId,
  }) async {
    await tutorsRepo.assign(courseId: courseId, tutorId: tutorId);
    getTutors();
  }

  Future deactivate({required String tutorId}) async {
    await tutorsRepo.deactivate(tutorId: tutorId);
    getTutors();
  }

  Future delete({required String tutorId}) async {
    await tutorsRepo.delete(tutorId: tutorId);
    getTutors();
  }
}
