import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter_test/flutter_test.dart';
import 'package:tasker/src/model.dart';
import 'package:tasker/src/task_rules.dart';

void main() {
  final day = DateTime(2026, 11, 6);
  final at8 = day.add(const Duration(hours: 8));

  FarmTask task({
    DateTime? taskDay,
    String assignee = 'worker',
    DateTime? notBefore,
    DateTime? startBy,
    DateTime? expiresAt,
    Duration? timeLimit,
    DateTime? startedAt,
    DateTime? doneAt,
  }) =>
      FarmTask(
        id: 'a',
        kind: TaskKind.seed,
        title: 'Seed',
        assigneeId: assignee,
        day: taskDay ?? day,
        updatedAt: 0,
        notBefore: notBefore,
        startBy: startBy,
        expiresAt: expiresAt,
        timeLimit: timeLimit,
        startedAt: startedAt,
        doneAt: doneAt,
      );

  group('stateOf', () {
    test('a plain task is ready', () => expect(stateOf(task(), at8), TaskState.ready));

    test('waits until its start time', () {
      final t = task(notBefore: at8.add(const Duration(hours: 1)));
      expect(stateOf(t, at8), TaskState.waiting);
      expect(stateOf(t, at8.add(const Duration(hours: 1))), TaskState.ready);
    });

    test('is missed past its deadline unless started', () {
      final deadline = at8.add(const Duration(hours: 4));
      expect(stateOf(task(startBy: deadline), deadline), TaskState.missed);
      expect(stateOf(task(startBy: deadline, startedAt: at8), deadline), TaskState.inProgress);
    });

    test('runs over its time limit but can still finish', () {
      final t = task(startedAt: at8, timeLimit: const Duration(minutes: 30));
      expect(stateOf(t, at8.add(const Duration(minutes: 29))), TaskState.inProgress);
      final late = stateOf(t, at8.add(const Duration(minutes: 40)));
      expect(late, TaskState.overdue);
      expect(canFinish(late), isTrue);
    });

    test('expiry beats everything except done', () {
      final end = at8.add(const Duration(hours: 1));
      expect(stateOf(task(expiresAt: end, startedAt: at8), end), TaskState.expired);
      expect(stateOf(task(expiresAt: end, startedAt: at8, doneAt: at8), end), TaskState.done);
    });
  });

  test('TTL for a future day counts from that day', () {
    final nextWeek = day.add(const Duration(days: 7));
    expect(expiryFrom(nextWeek, at8, const Duration(hours: 2)),
        nextWeek.add(const Duration(hours: 2)));
    expect(expiryFrom(day, at8, const Duration(hours: 2)), at8.add(const Duration(hours: 2)));
  });

  group('dayListFor', () {
    test('only my tasks, active work first', () {
      final list = dayListFor(
          'worker',
          [
            task(doneAt: at8),
            task(assignee: 'someone-else'),
            task(startedAt: at8),
          ],
          at8);
      expect(list.map((t) => stateOf(t, at8)), [TaskState.inProgress, TaskState.done]);
    });

    test('carries unfinished work over, but not lapsed work or future work', () {
      final yesterday = day.subtract(const Duration(days: 1));
      final tomorrow = day.add(const Duration(days: 1));
      expect(dayListFor('worker', [task(taskDay: yesterday)], at8), hasLength(1));
      expect(dayListFor('worker', [task(taskDay: yesterday, doneAt: yesterday)], at8), isEmpty);
      expect(dayListFor('worker', [task(taskDay: yesterday, expiresAt: yesterday)], at8), isEmpty);
      expect(dayListFor('worker', [task(taskDay: tomorrow)], at8), isEmpty);
    });
  });

  group('isAtPlace', () {
    const place = Place(
      id: 'p',
      name: 'P',
      icon: TaskKindIcon.any,
      mapX: 0,
      mapY: 0,
      lat: 33.12,
      lng: -117.08,
      radiusM: 50,
    );

    test('near passes, far fails, no fix fails', () {
      expect(isAtPlace(place, const GeoFix(33.1201, -117.08)), isTrue); // about 11 m
      expect(isAtPlace(place, const GeoFix(33.123, -117.08)), isFalse); // about 330 m
      expect(isAtPlace(place, null), isFalse);
    });

    test('a weak fix gets the benefit of the doubt', () {
      expect(isAtPlace(place, const GeoFix(33.1209, -117.08, accuracyM: 80)), isTrue); // about 100 m
    });
  });

  test('a task survives a JSON round trip', () {
    final t = task(notBefore: at8, timeLimit: const Duration(minutes: 15), startedAt: at8);
    final back = FarmTask.fromJson(t.id, 5, t.toJson());
    expect(back.notBefore, at8);
    expect(back.timeLimit, const Duration(minutes: 15));
    expect(back.startedAt, at8);
    expect(back.updatedAt, 5);
  });
}

abstract final class TaskKindIcon {
  static const any = IconData(0xe000);
}
