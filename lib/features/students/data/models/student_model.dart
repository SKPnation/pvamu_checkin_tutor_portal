import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';


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

  // -------------------- parsing helper --------------------
  static DateTime? _asDate(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  static DocumentReference<Map<String,dynamic>>? _asRef(dynamic v) {
    if (v is DocumentReference) {
      return v.withConverter(
        fromFirestore: (s,_)=>s.data()??{},
        toFirestore: (d,_)=>d,
      );
    }
    return null;
  }

  static Future<Student> fromMapAsync(Map<String,dynamic> map,String docId) async {

    Course? course;
    final cRef = _asRef(map['course']);
    if (cRef != null) course = await getCourse(cRef);

    Tutor? tutor;
    final tRef = _asRef(map['tutor']);
    if (tRef != null) tutor = await getTutor(tRef);

    return Student(
      id: docId,
      name: map['name'] ?? map['name_lower'] ?? '',
      email: map['email'] ?? '',
      createdAt: _asDate(map['created_at']),
      timeIn:    _asDate(map['time_in']),
      timeOut:   _asDate(map['time_out']),
      course: course,
      tutor: tutor,
    );
  }

  // -------------------- serialization --------------------
  Map<String,dynamic> toMap({bool forFirestore=true}) {

    return {
      'id': id,
      'name': name,
      'email': email,
      // DATE SAFE FOR BOTH firestore & getStorage
      'created_at': createdAt?.toIso8601String(),
      'time_in':    timeIn?.toIso8601String(),
      'time_out':   timeOut?.toIso8601String(),
      // firestore only (string id stored)
      'course': course?.id,
      'tutor': tutor?.id,
    };
  }
}
