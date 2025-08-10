import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

abstract class TutorsRepo{
  Future<void> addTutor(Tutor tutor);

}