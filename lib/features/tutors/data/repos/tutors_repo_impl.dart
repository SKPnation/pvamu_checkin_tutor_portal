import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/domain/repos/tutors_repo.dart';

class TutorsRepoImpl extends TutorsRepo {
  final CollectionReference tutorsCollection = FirebaseFirestore.instance
      .collection('tutors');

  @override
  Future<void> addTutor(tutor) async {
    try {
      final data = Map<String, dynamic>.from(tutor.toMap());
      await tutorsCollection.doc(tutor.toMap()['id']).set(data);

      Get.back();

      CustomSnackBar.successSnackBar(body: "Added new tutor");
    } catch (e) {
      CustomSnackBar.errorSnackBar("Failed: $e");
      // Handle failure here
    }
  }
}
