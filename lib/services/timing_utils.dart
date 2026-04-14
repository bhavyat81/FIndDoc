import '../models/time_slot.dart';

/// Returns the current day key (e.g., 'mon', 'tue', ..., 'sun').
String todayKey() {
  const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  return days[DateTime.now().weekday - 1];
}

/// Returns true if the current time falls within any of the given slots.
bool isOpenNow(Map<String, List<TimeSlot>> timings) {
  final slots = timings[todayKey()];
  if (slots == null || slots.isEmpty) return false;
  final now = DateTime.now();
  for (final slot in slots) {
    final from = _parseTime(slot.from);
    final to = _parseTime(slot.to);
    final nowMinutes = now.hour * 60 + now.minute;
    if (nowMinutes >= from && nowMinutes <= to) return true;
  }
  return false;
}

int _parseTime(String time) {
  final parts = time.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

/// Returns today's timing slots as a human-readable string.
String todayTimingString(Map<String, List<TimeSlot>> timings) {
  final slots = timings[todayKey()];
  if (slots == null || slots.isEmpty) return 'Closed today';
  return slots.map((s) => '${_formatTime(s.from)} – ${_formatTime(s.to)}').join(', ');
}

String _formatTime(String time) {
  final parts = time.split(':');
  int hour = int.parse(parts[0]);
  final min = parts[1];
  final period = hour >= 12 ? 'PM' : 'AM';
  if (hour > 12) hour -= 12;
  if (hour == 0) hour = 12;
  if (min == '00') return '$hour $period';
  return '$hour:$min $period';
}

/// Returns a short weekly summary like "Mon–Sat: 10 AM – 1 PM, 5–8 PM\nSun: Closed"
String weeklyTimingSummary(Map<String, List<TimeSlot>> timings) {
  const dayOrder = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  const dayLabels = {
    'mon': 'Mon', 'tue': 'Tue', 'wed': 'Wed', 'thu': 'Thu',
    'fri': 'Fri', 'sat': 'Sat', 'sun': 'Sun',
  };
  final lines = <String>[];
  for (final day in dayOrder) {
    final slots = timings[day];
    if (slots == null || slots.isEmpty) {
      lines.add('${dayLabels[day]}: Closed');
    } else {
      final timeStr =
          slots.map((s) => '${_formatTime(s.from)} – ${_formatTime(s.to)}').join(', ');
      lines.add('${dayLabels[day]}: $timeStr');
    }
  }
  return lines.join('\n');
}
