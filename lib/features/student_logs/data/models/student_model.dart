import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/repos/courses_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/data/repos/student_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/repos/tutors_repo_impl.dart';

class Student {
  final String? id;
  final String? name;
  final String? email;
  final Course? course;
  final Tutor? tutor;
  final DateTime? createdAt;
  final DateTime? timeIn;
  final DateTime? timeOut;

  const Student({
    this.id,
    this.name,
    this.email,
    this.course,
    this.tutor,
    this.createdAt,
    this.timeIn,
    this.timeOut,
  });

  // --- Helpers ---------------------------------------------------------------

  // Narrow a dynamic to a typed DocumentReference with safety.
  static DocumentReference<Map<String, dynamic>>? _asMapRef(dynamic v) {
    if (v is DocumentReference) {
      // Narrow Object? -> Map<String, dynamic> via converter
      return v.withConverter<Map<String, dynamic>>(
        fromFirestore: (snap, _) => snap.data() ?? <String, dynamic>{},
        toFirestore: (data, _) => data,
      );
    }
    return null;
  }

  static DateTime? _tsToDate(dynamic v) => (v is Timestamp) ? v.toDate() : null;

  // --- Async mapper (safe) ---------------------------------------------------

  static Future<Student> fromMapAsync(
      Map<String, dynamic> map,
      String docId,
      ) async {
    // Safe timestamp reads
    final createdAt = _tsToDate(map['created_at']);
    final timeIn    = _tsToDate(map['time_in']);
    final timeOut   = _tsToDate(map['time_out']);

    // Safe refs (may be null or missing)
    final courseRef = _asMapRef(map['course']);
    final tutorRef  = _asMapRef(map['tutor']);

    // Fetch related docs only if refs exist
    Course? course;
    if (courseRef != null) {
      course = await getCourse(courseRef);
    }

    Tutor? tutor;
    if (tutorRef != null) {
      tutor = await getTutor(tutorRef);
    }

    return Student(
      id: docId,
      // Prefer canonical "name" if present, fall back to lowercased alias
      name: (map['name'] as String?) ?? (map['name_lower'] as String?) ?? '',
      email: map['email'] as String? ?? '',
      createdAt: createdAt,
      timeIn: timeIn,
      timeOut: timeOut,
      course: course,
      tutor: tutor,
    );
  }

  // --- Serializer (safe) -----------------------------------------------------

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};

    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;

    if (createdAt != null) data['created_at'] = Timestamp.fromDate(createdAt!);
    if (timeIn != null)    data['time_in']    = Timestamp.fromDate(timeIn!);
    if (timeOut != null)   data['time_out']   = Timestamp.fromDate(timeOut!);

    // Only write refs if we actually have linked models & ids
    if (course?.id != null) {
      data['course'] = CoursesRepoImpl().coursesCollection.doc(course!.id);
    }
    if (tutor?.id != null) {
      // ✅ Fix: use tutors collection, not students collection
      data['tutor'] = TutorsRepoImpl().tutorsCollection.doc(tutor!.id);
    }

    return data;
  }
}
