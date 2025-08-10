import 'package:intl/intl.dart';

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
