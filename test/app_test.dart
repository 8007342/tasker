import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasker/main.dart';
import 'package:tasker/src/location.dart';
import 'package:tasker/src/model.dart';
import 'package:tasker/src/sync_api.dart';
import 'package:tasker/src/task_rules.dart';
import 'package:tasker/src/task_store.dart';

class NoServer implements SyncApi {
  @override
  Future<List<SyncRecord>> sync(List<SyncRecord> changes) async => throw Exception('offline');
}

class FixedLocation implements LocationService {
  FixedLocation(this.fix);
  final GeoFix? fix;
  @override
  Future<GeoFix?> current() async => fix;
}

void main() {
  late TaskStore store;

  Future<void> pumpApp(WidgetTester tester, {GeoFix? fix}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(TaskerApp(store: store, location: FixedLocation(fix)));
    await tester.pump();
  }

  Future<void> open(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = TaskStore(await SharedPreferences.getInstance(), NoServer());
  });

  testWidgets('landing shows Admin and Worker buttons', (tester) async {
    await pumpApp(tester);
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('Worker'), findsOneWidget);
  });

  testWidgets('a worker sees a task, starts it and finishes it, with no signal', (tester) async {
    store.addTask(kind: TaskKind.seed, assigneeId: 'worker', day: dayOf(DateTime.now()));
    await pumpApp(tester);
    await open(tester, 'Worker');

    expect(find.text('Seed'), findsOneWidget);
    await tester.tap(find.text('Start'));
    await tester.pump();
    expect(find.text('Working'), findsOneWidget);
    await tester.tap(find.text('Done').first);
    await tester.pump();
    expect(stateOf(store.tasks.single, DateTime.now()), TaskState.done);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('being too far away blocks the start and shows where to go', (tester) async {
    store.savePlaceGps('barn', const GeoFix(33.12, -117.08));
    store.addTask(
      kind: TaskKind.feed,
      assigneeId: 'worker',
      day: dayOf(DateTime.now()),
      placeId: 'barn',
      mustBeAtPlace: true,
    );
    await pumpApp(tester, fix: const GeoFix(33.2, -117.08));
    await open(tester, 'Worker');

    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Go to Barn'), findsOneWidget);
    expect(store.tasks.single.startedAt, isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the admin creates a task that lands on the worker list', (tester) async {
    await pumpApp(tester);
    await open(tester, 'Admin');
    await tester.tap(find.text('New task'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Water'));
    await tester.pump();
    await tester.tap(find.text('Save and assign'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final list = dayListFor('worker', store.tasks, DateTime.now());
    expect(list.single.kind, TaskKind.water);
    expect(find.text('Water'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
