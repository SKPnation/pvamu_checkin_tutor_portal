import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/domain/repos/student_repo.dart';

class StudentRepoImpl extends StudentRepo {
  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');

  @override
  Future<List<Student>> getStudentLogs() async {
    final querySnapshot = await studentsCollection.get();
    List<Student> students =
        querySnapshot.docs.map((doc) {
          return Student.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

    return students;
  }
}
