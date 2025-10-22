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
  final assignedTutors = <AssignedModel>[].obs;
  final isAssignedLoading = false.obs;
  final assignedError = ''.obs;

  var isLoading = false.obs;
  var error = ''.obs;
  var selectedCourseIndex = "-1".obs;

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

  //--- TUTORS ---
  Future<void> getTutors() async => tutors.value = await tutorsRepo.getTutors();

  Future deactivate({required String tutorId}) async {
    await tutorsRepo.deactivate(tutorId: tutorId);
    getTutors();
  }

  Future delete({required String tutorId}) async {
    await tutorsRepo.delete(tutorId: tutorId);
    getTutors();
  }

  //--- ASSIGNED TUTORS ---
  Future<void> fetchAssignedTutors() async {
    isAssignedLoading.value = true;
    assignedError.value = '';
    try {
      final list = await tutorsRepo.getAssignedTutors();
      assignedTutors.assignAll(list);
    } catch (e) {
      assignedError.value = e.toString();
    } finally {
      isAssignedLoading.value = false;
    }
  }

  Future<void> assignToCourse({
    required String courseId,
    required String tutorId,
  }) async {
    await tutorsRepo.assign(courseId: courseId, tutorId: tutorId);
    // refresh the table source, not just tutors
    await fetchAssignedTutors();
  }

  Future<void> unAssignToCourse({
    required String courseId,
    required String tutorId,
  }) async {
    await tutorsRepo.unAssign(courseId: courseId, tutorId: tutorId);
    // refresh the table source, not just tutors
    await fetchAssignedTutors();
  }


}
