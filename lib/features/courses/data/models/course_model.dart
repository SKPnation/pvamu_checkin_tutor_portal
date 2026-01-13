import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String? id;
  final String? code;
  final String? name;
  final String? status;
  final DateTime? createdAt;

  Course( {
    this.id,
    required this.code,
    required this.name,
    this.status,
    required this.createdAt,
  });

  factory Course.fromMap(Map<String, dynamic> map, String docId)
 {
    return Course(
      id: map['id'],
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      status: map['status'] ?? '',
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt!),
    };
  }
}
