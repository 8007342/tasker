import 'dart:math' as math;

import 'model.dart';

/// Derived, never stored, so a phone that sat offline is right as soon as it reads its clock.
enum TaskState { waiting, ready, inProgress, overdue, done, missed, expired }

DateTime dayOf(DateTime t) => DateTime(t.year, t.month, t.day);

TaskState stateOf(FarmTask task, DateTime now) {
  if (task.doneAt != null) return TaskState.done;
  if (task.expiresAt != null && !now.isBefore(task.expiresAt!)) return TaskState.expired;
  if (task.startedAt != null) {
    final limit = task.timeLimit;
    final late = limit != null && !now.isBefore(task.startedAt!.add(limit));
    return late ? TaskState.overdue : TaskState.inProgress;
  }
  if (task.startBy != null && !now.isBefore(task.startBy!)) return TaskState.missed;
  if (task.notBefore != null && now.isBefore(task.notBefore!)) return TaskState.waiting;
  return TaskState.ready;
}

bool canStart(TaskState s) => s == TaskState.ready;
bool canFinish(TaskState s) => s == TaskState.inProgress || s == TaskState.overdue;
bool isOpen(TaskState s) =>
    s == TaskState.ready || s == TaskState.waiting || canFinish(s);

/// TTL counts from the later of now and the assigned day, so a task planned for next week
/// doesn't expire before its day.
DateTime expiryFrom(DateTime day, DateTime now, Duration ttl) =>
    (now.isAfter(day) ? now : day).add(ttl);

/// A worker's list for [now]'s day: that day's tasks, plus earlier ones still doable.
List<FarmTask> dayListFor(String personId, Iterable<FarmTask> tasks, DateTime now) {
  final today = dayOf(now);
  final list = tasks.where((t) {
    if (t.assigneeId != personId) return false;
    if (t.day.isAtSameMomentAs(today)) return true;
    if (t.day.isAfter(today)) return false;
    final s = stateOf(t, now);
    return canStart(s) || canFinish(s) || s == TaskState.waiting;
  }).toList();
  list.sort((a, b) {
    final byRank = _rank(stateOf(a, now)).compareTo(_rank(stateOf(b, now)));
    if (byRank != 0) return byRank;
    final byDay = a.day.compareTo(b.day);
    return byDay != 0 ? byDay : a.id.compareTo(b.id);
  });
  return list;
}

int _rank(TaskState s) => const {
      TaskState.overdue: 0,
      TaskState.inProgress: 1,
      TaskState.ready: 2,
      TaskState.waiting: 3,
      TaskState.done: 4,
      TaskState.missed: 5,
      TaskState.expired: 6,
    }[s]!;

double distanceM(double lat1, double lng1, double lat2, double lng2) {
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1), dLng = rad(lng2 - lng1);
  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.pow(math.sin(dLng / 2), 2);
  return 6371000 * 2 * math.asin(math.sqrt(a));
}

/// Allows for the fix's accuracy: a weak fix must not lock out someone standing in the field.
bool isAtPlace(Place place, GeoFix? fix) {
  if (!place.hasGps) return true;
  if (fix == null) return false;
  return distanceM(place.lat!, place.lng!, fix.lat, fix.lng) - fix.accuracyM <= place.radiusM;
}
