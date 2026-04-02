DateTime? clampTutorTimeOutTo5Pm(DateTime? timeIn, DateTime? timeOut) {
  if (timeIn == null) return null;
  if (timeOut == null) return null;

  final latestAllowed = DateTime(
    timeIn.year,
    timeIn.month,
    timeIn.day,
    17,
    0,
    0,
  );

  return timeOut.isAfter(latestAllowed) ? latestAllowed : timeOut;
}

Duration? calculateTutorBusinessCappedDuration({
  required DateTime? timeIn,
  required DateTime? timeOut,
  required bool includeOngoing,
}) {
  if (timeIn == null) return null;

  final rawEnd = timeOut ?? (includeOngoing ? DateTime.now() : null);
  if (rawEnd == null) return null;

  final effectiveEnd = clampTutorTimeOutTo5Pm(timeIn, rawEnd);
  if (effectiveEnd == null || effectiveEnd.isBefore(timeIn)) return null;

  final raw = effectiveEnd.difference(timeIn);
  const maxDuration = Duration(hours: 5);

  return raw > maxDuration ? maxDuration : raw;
}