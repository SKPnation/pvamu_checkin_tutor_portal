import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/domain/repos/student_repo.dart';

class StudentRepoImpl extends StudentRepo {
  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');

  @override
  Future<List<Student>> getStudentLogs() async {
    final querySnapshot = await studentsCollection.get();

    return await Future.wait(
      querySnapshot.docs.map((doc) async {
        return await Student.fromMapAsync(doc.data() as Map<String, dynamic>, doc.id);
      }),
    );
  }
}
