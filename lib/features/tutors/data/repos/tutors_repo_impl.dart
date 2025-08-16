import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/assigned_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/domain/repos/tutors_repo.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class TutorsRepoImpl extends TutorsRepo {
  final CollectionReference tutorsCollection = FirebaseFirestore.instance
      .collection('tutors');
  final CollectionReference assignedCollection = FirebaseFirestore.instance
      .collection('assigned');

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

  @override
  Future<List<Tutor>> getTutors() async {
    final querySnapshot = await tutorsCollection.get();
    List<Tutor> tutors =
        querySnapshot.docs.map((doc) {
          return Tutor.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

    return tutors;
  }

  @override
  Future<void> assign({
    required String courseId,
    required String tutorId,
  }) async {
    final tutorRef = FirebaseFirestore.instance.doc('/tutors/$tutorId');
    final courseRef = FirebaseFirestore.instance.doc('/courses/$courseId');

    try {
      final querySnapshot =
          await assignedCollection.where("tutor", isEqualTo: tutorRef).get();

      var coursesRefs = <DocumentReference>[];

      if (querySnapshot.docs.isNotEmpty) {
        var mapObject = querySnapshot.docs.single.data() as Map<String, dynamic>;

        coursesRefs = (mapObject['courses'] as List<dynamic>)
            .cast<DocumentReference>();

        coursesRefs.add(courseRef);

        await assignedCollection.doc(mapObject['id']).update({
          "courses": coursesRefs,
        });

        CustomSnackBar.successSnackBar(body: "Assigned successfully");

      } else {
        final id = assignedCollection.doc().id;
        final data = <String, dynamic>{
          "id": id,
          "courses": [courseRef],
          "tutor": tutorRef,
          "created_at": DateTime.now(),
        };

        await assignedCollection.doc(id).set(data);
        CustomSnackBar.successSnackBar(body: "Assigned successfully");
      }

      final docSnapshot = await courseRef.get();

      List<DocumentReference> tutors = [];
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['tutors'] != null) {
          tutors = List<DocumentReference>.from(data['tutors']);
        }
      }

      tutors.add(tutorRef);

      await courseRef.update({"tutors": tutors});

      TutorsController.instance.selectedTutor = null;
      CoursesController.instance.selectedCourse = null;

    } catch (e) {
      print("Failed: $e");
      CustomSnackBar.errorSnackBar("Failed: $e");
      // Handle failure here
    }
  }

  @override
  Future<List<AssignedModel>> getAssignedTutors() async{
    final querySnapshot = await assignedCollection.get();
    final docs = querySnapshot.docs;

    List<AssignedModel> assignedTutors = [];

    for (var doc in docs) {
      Tutor? tutor;
      final tutorRef = doc['tutor'] as DocumentReference;
      final tutorSnapshot = await tutorRef.get();
      if (tutorSnapshot.exists) {
        tutor = Tutor.fromMap(tutorSnapshot.data() as Map<String, dynamic>);
      }

      // resolve courses
      final courseRefs = (doc['courses'] as List?)?.cast<DocumentReference>() ?? [];
      final courseSnapshots = await Future.wait(courseRefs.map((e) => e.get()));

      final courses = courseSnapshots
          .where((snap) => snap.exists)
          .map((snap) => Course.fromMap(snap.data() as Map<String, dynamic>))
          .toList();

      // build model
      assignedTutors.add(
        AssignedModel(
          id: doc.id,
          tutor: tutor,
          courses: courses,
          createdAt: doc['created_at']?.toDate()
        ),
      );
    }

    return assignedTutors;
  }
}
