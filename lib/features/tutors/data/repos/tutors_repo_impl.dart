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
  final CollectionReference coursesCollection = FirebaseFirestore.instance
      .collection('courses');
  final CollectionReference tutorsCollection = FirebaseFirestore.instance
      .collection('tutors');
  final CollectionReference assignedCollection = FirebaseFirestore.instance
      .collection('assigned');

  DocumentReference<Map<String, dynamic>> tutorRef(String tutorId) =>
      FirebaseFirestore.instance.doc('/tutors/$tutorId');

  DocumentReference<Map<String, dynamic>> workScheduleRef(String tutorId) =>
      FirebaseFirestore.instance.doc('/tutor_availability/$tutorId');

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
        var mapObject =
            querySnapshot.docs.single.data() as Map<String, dynamic>;

        coursesRefs =
            (mapObject['courses'] as List<dynamic>).cast<DocumentReference>();

        coursesRefs.add(courseRef);

        await assignedCollection.doc(mapObject['id']).update({
          "courses": coursesRefs,
        });

        Get.back();

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

        Get.back();

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
  Future<void> unAssign({
    required String courseId,
    required String tutorId,
  }) async {
    final tutorRef = FirebaseFirestore.instance.doc('/tutors/$tutorId');
    final courseRef = FirebaseFirestore.instance.doc('/courses/$courseId');

    try {
      // 1 Find the "assigned" record for this tutor
      final querySnapshot =
          await assignedCollection.where("tutor", isEqualTo: tutorRef).get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.single;
        final data = doc.data() as Map<String, dynamic>;

        List<DocumentReference> courseRefs =
            (data['courses'] as List<dynamic>).cast<DocumentReference>();

        // 2 Remove the course reference from the tutor's "courses" list
        courseRefs.removeWhere((ref) => ref.path == courseRef.path);

        if (courseRefs.isEmpty) {
          // if tutor has no more assigned courses, delete the doc
          await assignedCollection.doc(data['id']).delete();
        } else {
          await assignedCollection.doc(data['id']).update({
            "courses": courseRefs,
          });
        }
      }

      // 3 Remove the tutor from the course's "tutors" array
      final courseSnapshot = await courseRef.get();
      if (courseSnapshot.exists) {
        final data = courseSnapshot.data();

        if (data != null && data['tutors'] != null) {
          List<DocumentReference> tutors = List<DocumentReference>.from(
            data['tutors'],
          );
          tutors.removeWhere((ref) => ref.path == tutorRef.path);

          await courseRef.update({"tutors": tutors});
        }
      }

      // 4 Clear selected fields in controllers
      TutorsController.instance.selectedTutor = null;
      CoursesController.instance.selectedCourse = null;

      Get.back();

      // 5 Notify success
      CustomSnackBar.successSnackBar(body: "Tutor unassigned successfully");
    } catch (e) {
      print("Failed to unassign: $e");
      CustomSnackBar.errorSnackBar("Failed to unassign: $e");
    }
  }

  @override
  Future<List<AssignedModel>> getAssignedTutors() async {
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
      final courseRefs =
          (doc['courses'] as List?)?.cast<DocumentReference>() ?? [];
      final courseSnapshots = await Future.wait(courseRefs.map((e) => e.get()));

      final courses =
          courseSnapshots
              .where((snap) => snap.exists)
              .map(
                (snap) => Course.fromMap(snap.data() as Map<String, dynamic>),
              )
              .toList();

      // build model
      assignedTutors.add(
        AssignedModel(
          id: doc.id,
          tutor: tutor,
          courses: courses,
          createdAt: doc['created_at']?.toDate(),
        ),
      );
    }

    return assignedTutors;
  }

  @override
  Future<void> deactivate({required String tutorId}) async {
    final data = <String, dynamic>{"blocked_at": DateTime.now()};

    await tutorsCollection.doc(tutorId).update(data);
  }

  @override
  Future<void> delete({required String tutorId}) async {
    final querySnapshot =
        await assignedCollection
            .where("tutor", isEqualTo: tutorRef(tutorId))
            .get();

    if (querySnapshot.size != 0) {
      //1. Get assigned tutor doc reference
      final assignedRef = querySnapshot.docs.first.reference;

      //2. Delete the assigned doc
      await assignedRef.delete();

      // 3. Find all "courses" docs where 'tutors' array contains this tutorRef
      final coursesQuery =
          await coursesCollection
              .where("tutors", arrayContains: tutorRef(tutorId))
              .get();

      //4. Loop through each and remove the reference from the array
      final futures = coursesQuery.docs.map((doc) {
        return doc.reference.update({
          'tutors': FieldValue.arrayRemove([tutorRef(tutorId)]),
        });
      });

      await Future.wait(futures);

      //5. Delete the "tutor doc" from the "tutors" collection
      await tutorRef(tutorId).delete();

      CustomSnackBar.successSnackBar(body: "Deleted successfully");
    }
  }

  @override
  Future<Tutor> getProfile({required String tutorId}) async {
    DocumentSnapshot<Map<String, dynamic>> profileSnapshot =
        await tutorRef(tutorId).get();
    DocumentSnapshot<Map<String, dynamic>> workScheduleSnapshot =
        await workScheduleRef(tutorId).get();
    Map<String, dynamic> profile =
        profileSnapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> workSchedule =
        workScheduleSnapshot.data() as Map<String, dynamic>;
    profile.addAll({"work_schedule": workSchedule});
    Tutor tutor = Tutor.fromMap(profile);
    return tutor;
  }
}
