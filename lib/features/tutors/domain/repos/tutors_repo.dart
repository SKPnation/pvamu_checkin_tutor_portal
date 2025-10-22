import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/assigned_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

abstract class TutorsRepo{
  Future<void> addTutor(Tutor tutor);
  Future<List<Tutor>> getTutors();
  Future<List<AssignedModel>> getAssignedTutors();
  Future<void> assign({required String courseId, required String tutorId});
  Future<void> unAssign({required String courseId, required String tutorId});
  Future<void> deactivate({required String tutorId});
  Future<void> delete({required String tutorId});
}