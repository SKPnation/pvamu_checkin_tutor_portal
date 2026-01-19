import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

String formatTime(DateTime? time) {
  if (time == null) return '--';
  return DateFormat('h:mm a').format(time).toUpperCase(); // e.g., 12:15pm
}

String formatDate(DateTime? date) {
  if (date == null) return '--';
  return DateFormat('MM/dd/yyyy').format(date); // e.g., 12/28/25
}

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);

  List<String> parts = [];
  if (h > 0) parts.add('${h}h');
  if (m > 0) parts.add('${m}m');
  if (s > 0 || parts.isEmpty) parts.add('${s}s');

  return parts.join(' ');
}

Future<Course> getCourse(DocumentReference docRef) async {
  final courseSnap = await docRef.get();
  return Course.fromMap(
    courseSnap.data() as Map<String, dynamic>,
    courseSnap.id,
  );
}

Future<Course> getCourseFromStudent(DocumentReference docRef) async {
  final studentSnap = await docRef.get();
  final studentData = studentSnap.data() as Map<String, dynamic>;

  final studentDoc = await Student.fromMapAsync(studentData, studentSnap.id);

  final course = studentDoc.course!;
  return course;
}

Future<Tutor> getTutor(DocumentReference docRef) async {
  final tutorSnap = await docRef.get();
  return Tutor.fromMap(tutorSnap.data() as Map<String, dynamic>);
}

Future<Student> getStudent(DocumentReference docRef) async {
  final studentSnap = await docRef.get();
  return Student.fromMapAsync(
    studentSnap.data() as Map<String, dynamic>,
    docRef.id,
  );
}

Future<List<Course>> getAssignedCourses(List<dynamic> coursesRefs) async {
  List<Course> courses = [];

  for (var ref in coursesRefs) {
    if (ref is DocumentReference) {
      final courseSnap = await ref.get();
      if (courseSnap.exists) {
        courses.add(
          Course.fromMap({
            'id': courseSnap.id,
            ...courseSnap.data() as Map<String, dynamic>,
          }, courseSnap.id),
        );
      }
    }
  }

  return courses;
}

Map<String, dynamic> encodeFirestoreForJson(Map<String, dynamic> input) {
  dynamic encode(dynamic v) {
    if (v == null) return null;

    if (v is Timestamp) {
      // pick one: ISO string or millisecondsSinceEpoch
      return v.toDate().toIso8601String();
      // return v.millisecondsSinceEpoch;  // alternative
    }
    if (v is DateTime) return v.toIso8601String();
    if (v is GeoPoint)
      return {
        '_geo': {'lat': v.latitude, 'lng': v.longitude},
      };
    if (v is DocumentReference) return {'_ref': v.path};

    if (v is List) return v.map(encode).toList();
    if (v is Map) {
      return v.map((k, val) => MapEntry(k.toString(), encode(val)));
    }
    return v;
  }

  return input.map((k, v) => MapEntry(k, encode(v)));
}

Future<void> deleteFromStorageByUrl(String downloadUrl) async {
  try {
    final ref = FirebaseStorage.instance.refFromURL(downloadUrl);
    await ref.delete();
    print('File deleted successfully');
  } catch (e) {
    print('Delete failed: $e');
    rethrow;
  }
}
