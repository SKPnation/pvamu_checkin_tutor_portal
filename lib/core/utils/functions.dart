import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

String formatTime(DateTime? time) {
  if (time == null) return 'N/A';
  return DateFormat('h:mm a').format(time).toUpperCase(); // e.g., 12:15pm
}

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);

  List<String> parts = [];
  if (h > 0) parts.add('${h}h');
  if (m > 0) parts.add('${m}m');
  if (s > 0 || parts.isEmpty) parts.add('${s}s');

  return parts.join(' ');
}

Future<Course> getCourse(DocumentReference docRef) async {
  final courseSnap = await docRef.get();
  return Course.fromMap(
    courseSnap.data() as Map<String, dynamic>,
  );
}

Future<Tutor> getTutor(DocumentReference docRef) async {
  final tutorSnap = await docRef.get();
  return Tutor.fromMap(
    tutorSnap.data() as Map<String, dynamic>,
  );
}