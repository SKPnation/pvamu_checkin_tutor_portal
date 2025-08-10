import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String? id;
  final String? name;
  final String? code;
  final String? category;
  final String? status;
  final DateTime? createdAt;

  Course( {
    this.id,
    required this.name,
    required this.code,
    this.status,
    required this.category,
    required this.createdAt,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      category: map['category'] ?? '',
      status: map['status'] ?? '',
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'category': category,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt!),
    };
  }
}
