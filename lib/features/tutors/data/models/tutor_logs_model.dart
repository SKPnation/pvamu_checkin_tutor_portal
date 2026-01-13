import 'package:cloud_firestore/cloud_firestore.dart';

class TutorLoginHistory {
  final String? id;

  // Relations
  final String? tutorId;
  final DocumentReference? tutorRef;

  // Snapshot fields
  final String? tutorName;
  final String? tutorEmail;

  // Session timestamps
  final DateTime? timeIn;
  final DateTime? timeOut;

  // Metadata
  final DateTime? createdAt;
  final String? device;
  final String? ipAddress;

  TutorLoginHistory({
    this.id,
    this.tutorId,
    this.tutorRef,
    this.tutorName,
    this.tutorEmail,
    this.timeIn,
    this.timeOut,
    this.createdAt,
    this.device,
    this.ipAddress,
  });

  // ---------- FACTORY ----------

  factory TutorLoginHistory.fromMap(
      Map<String, dynamic> map,
      String docId,
      ) {
    return TutorLoginHistory(
      id: docId,
      tutorId: map['tutor_id'],
      tutorRef: map['tutor'],
      tutorName: map['tutor_name'],
      tutorEmail: map['tutor_email'],
      timeIn: _toDate(map['time_in']),
      timeOut: _toDate(map['time_out']),
      createdAt: _toDate(map['created_at']),
      device: map['device'],
      ipAddress: map['ip_address'],
    );
  }

  // ---------- SERIALIZERS ----------

  Map<String, dynamic> toMap() {
    return {
      'tutor_id': tutorId,
      'tutor': tutorRef,
      'tutor_name': tutorName,
      'tutor_email': tutorEmail,
      if (timeIn != null) 'time_in': Timestamp.fromDate(timeIn!),
      if (timeOut != null) 'time_out': Timestamp.fromDate(timeOut!),
      if (createdAt != null) 'created_at': Timestamp.fromDate(createdAt!),
      'device': device,
      'ip_address': ipAddress,
    };
  }

  Map<String, dynamic> toCacheMap() => {
    'id': id,
    'tutor_id': tutorId,
    'tutor_name': tutorName,
    'tutor_email': tutorEmail,
    'time_in': timeIn?.toIso8601String(),
    'time_out': timeOut?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
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
