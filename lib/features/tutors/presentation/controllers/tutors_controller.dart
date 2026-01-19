import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/web_image_upload.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/assigned_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/repos/tutors_repo_impl.dart';

class TutorsController extends GetxController {
  static TutorsController get instance => Get.find();

  final fNameTEC = TextEditingController();
  final lNameTEC = TextEditingController();
  final emailAddressTEC = TextEditingController();

  // Rx<Tutor>? selectedTutor;
  final Rxn<Tutor> selectedTutor = Rxn<Tutor>(); //

  TutorsRepoImpl tutorsRepo = TutorsRepoImpl();

  var tutors = <Tutor>[].obs;
  final assignedTutors = <AssignedModel>[].obs;
  final isAssignedLoading = false.obs;
  final profileLoading = false.obs;
  final assignedError = ''.obs;
  final editMode = false.obs;

  var isLoading = false.obs;
  var error = ''.obs;
  var selectedCourseIndex = "-1".obs;

  Future addTutor() async {
    await tutorsRepo.addTutor(
      Tutor(
        id: tutorsRepo.tutorsCollection.doc().id,
        fName: fNameTEC.text,
        lName: lNameTEC.text,
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

  Future activate({required String tutorId}) async {
    await tutorsRepo.activate(tutorId: tutorId);
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

  Future<Tutor> getProfile({required String tutorId}) async {
    Tutor tutor = await tutorsRepo.getProfile(tutorId: tutorId);
    return tutor;
  }

  Future setSchedule(
    String selectedDay,
    TimeOfDay startTime,
    TimeOfDay endTime,
    String tutorId,
  ) async {
    selectedDay = selectedDay.toLowerCase();
    final start = startTime.format(Get.context!); // e.g. "9:30 AM"
    final end = endTime.format(Get.context!);

    var input = {selectedDay: "$start - $end"};

    await tutorsRepo.setSchedule(input, tutorId);

    await getSelectedTutorProfile(tutorId);

    editMode.value = !editMode.value;

    CustomSnackBar.successSnackBar(
      body:
          "Availability set for $selectedDay "
          "from ${startTime.format(Get.context!)} "
          "to ${endTime.format(Get.context!)}",
    );
  }

  getSelectedTutorProfile(String tutorId) async {
    profileLoading.value = true;
    Tutor tutor = await getProfile(tutorId: tutorId);
    selectedTutor.value = tutor;

    profileLoading.value = false;
  }

  Future<List<TutorLoginHistory>> getTutorLogs() async =>
      await tutorsRepo.getTutorLogs();

  Future<void> updateProfilePicture(String tutorId) async {
    final bytes = await WebImageUploader.pickImageBytesWeb();
    if (bytes == null) return;


    final url = await WebImageUploader.uploadImage(
      bytes: bytes,
      folder: 'tutors_profile_photos',
    );

    print('Uploaded URL: $url');

    await tutorsRepo.updateProfilePicture(tutorId: tutorId, url: url!);

    await getSelectedTutorProfile(tutorId);
  }

  Future<void> deleteProfilePicture(
    String tutorId,
    String profilePhotoUrl,
  ) async {
    await tutorsRepo.deleteProfilePicture(tutorId, profilePhotoUrl);
    await getSelectedTutorProfile(tutorId);
  }
}
