import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

class StudentLoginHistory {
  final String? id;

  // Relations
  final String? studentId;
  final DocumentReference? studentRef;
  final Course? course;
  final Tutor? tutor;

  // Snapshot fields (avoid extra reads)
  final String? studentName;
  final String? studentEmail;

  // Session timestamps
  final DateTime? timeIn;
  final DateTime? timeOut;

  // Metadata
  final DateTime? createdAt;
  final String? goal;
  final String? device;
  final String? ipAddress;

  StudentLoginHistory({
    this.id,
    this.studentId,
    this.studentRef,
    this.course,
    this.tutor,
    this.studentName,
    this.studentEmail,
    this.timeIn,
    this.timeOut,
    this.createdAt,
    this.goal,
    this.device,
    this.ipAddress,
  });

  static DocumentReference<Map<String,dynamic>>? _asRef(dynamic v) {
    if (v is DocumentReference) {
      return v.withConverter(
        fromFirestore: (s,_)=>s.data()??{},
        toFirestore: (d,_)=>d,
      );
    }
    return null;
  }

  static Future<StudentLoginHistory> fromMapAsync(Map<String,dynamic> map,String docId) async {

    Tutor? tutor;
    Course? course;

    final dynamic courseField = map['course'];
    final dynamic tutorField = map['tutor'];

    DocumentReference? courseRef;
    DocumentReference? tutorRef;
    if (courseField is DocumentReference) {
      courseRef = courseField;
    } else if (courseField is String && courseField.isNotEmpty) {
      courseRef = FirebaseFirestore.instance.doc(courseField);
    }

    if (courseRef != null) {
      final snap = await courseRef.get();
      final data = snap.data() as Map<String, dynamic>?;
      if (data != null) {
        course = Course.fromMap(data, snap.id);
      }
    }

    if (tutorField is DocumentReference) {
      tutorRef = tutorField;
    } else if (tutorField is String && tutorField.isNotEmpty) {
      tutorRef = FirebaseFirestore.instance.doc(tutorField);
    }

    if (tutorRef != null) {
      final snap = await tutorRef.get();
      final data = snap.data() as Map<String, dynamic>?;
      if (data != null) {
        tutor = Tutor.fromMap(data);
      }
    }

    return StudentLoginHistory(
      id: docId,
      studentId: map['student_id'],
      studentRef: map['student'],
      course: course,
      tutor: tutor,
      studentName: map['student_name'],
      studentEmail: map['student_email'],
      timeIn: _toDate(map['time_in']),
      timeOut: _toDate(map['time_out']),
      createdAt: _toDate(map['created_at']),
      goal: map['goal'],
      device: map['device'],
      ipAddress: map['ip_address'],
    );
  }


  // // ---------- FACTORY ----------
  //
  // factory StudentLoginHistory.fromMap(
  //     Map<String, dynamic> map,
  //     String docId,
  //     ) {
  //   return StudentLoginHistory(
  //     id: docId,
  //     studentId: map['student_id'],
  //     studentRef: map['student'],
  //     studentName: map['student_name'],
  //     studentEmail: map['student_email'],
  //     timeIn: _toDate(map['time_in']),
  //     timeOut: _toDate(map['time_out']),
  //     createdAt: _toDate(map['created_at']),
  //     goal: map['goal'],
  //     device: map['device'],
  //     ipAddress: map['ip_address'],
  //   );
  // }

  // ---------- SERIALIZERS ----------

  /// Firestore write map
  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'student': studentRef,
      'student_name': studentName,
      'student_email': studentEmail,
      if (timeIn != null) 'time_in': Timestamp.fromDate(timeIn!),
      if (timeOut != null) 'time_out': Timestamp.fromDate(timeOut!),
      if (createdAt != null) 'created_at': Timestamp.fromDate(createdAt!),
      'goal': goal,
      'device': device,
      'ip_address': ipAddress,
    };
  }

  /// JSON-safe local cache
  Map<String, dynamic> toCacheMap() => {
    'id': id,
    'student_id': studentId,
    'student_name': studentName,
    'student_email': studentEmail,
    'time_in': timeIn?.toIso8601String(),
    'time_out': timeOut?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'goal': goal,
    'device': device,
    'ip_address': ipAddress,
  };

  // ---------- HELPERS ----------

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
