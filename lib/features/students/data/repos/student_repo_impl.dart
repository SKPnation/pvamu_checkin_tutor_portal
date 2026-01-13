import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/domain/repos/student_repo.dart';

class StudentRepoImpl extends StudentRepo {
  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');
  final CollectionReference<Map<String, dynamic>> loginHistoryCollection =
      FirebaseFirestore.instance.collection('student_login_history');

  @override
  Future<List<StudentLoginHistory>> getStudentLogs() async {
    final querySnapshot = await loginHistoryCollection.get();

    return await Future.wait(
      querySnapshot.docs.map((doc) async {
        return StudentLoginHistory.fromMapAsync(doc.data(), doc.id);
      }),
    );
  }

  @override
  Future<List<Student>> getStudents() async {
    final querySnapshot = await studentsCollection.get();

    return await Future.wait(
      querySnapshot.docs.map((doc) async {
        return await Student.fromMapAsync(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }),
    );
  }
}
