import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasker/src/model.dart';
import 'package:tasker/src/sync_api.dart';
import 'package:tasker/src/task_store.dart';

class FakeServer implements SyncApi {
  final Map<String, SyncRecord> rows = {};
  bool online = true;

  @override
  Future<List<SyncRecord>> sync(List<SyncRecord> changes) async {
    if (!online) throw Exception('no signal');
    for (final c in changes) {
      final old = rows[c.key];
      if (old == null || c.updatedAt >= old.updatedAt) rows[c.key] = c;
    }
    return rows.values.toList();
  }
}

void main() {
  var time = DateTime(2026, 11, 6, 8);
  DateTime clock() => time = time.add(const Duration(seconds: 1));
  final day = DateTime(2026, 11, 6);

  Future<TaskStore> phone(FakeServer server) async =>
      TaskStore(await SharedPreferences.getInstance(), server, clock: clock);

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('changes made offline wait, then reach the server', () async {
    final server = FakeServer()..online = false;
    final store = await phone(server);
    store.addTask(kind: TaskKind.seed, assigneeId: 'worker', day: day);
    await store.sync();
    expect(store.tasks, hasLength(1));
    expect(store.unsent, 1);
    expect(store.status, SyncStatus.waiting);
    expect(server.rows, isEmpty);

    server.online = true;
    await store.sync();
    expect(server.rows, hasLength(1));
    expect(store.unsent, 0);
    expect(store.status, SyncStatus.synced);
  });

  test('tasks and the unsent queue survive a restart', () async {
    final server = FakeServer()..online = false;
    final first = await phone(server);
    first.addTask(kind: TaskKind.water, assigneeId: 'worker', day: day);
    first.startTask(first.tasks.single.id);
    await first.sync();

    final again = await phone(server);
    expect(again.tasks.single.startedAt, isNotNull);
    expect(again.unsent, 1);
    server.online = true;
    await again.sync();
    expect(server.rows, hasLength(1));
  });

  test('a task assigned on one phone reaches another, and progress comes back', () async {
    final server = FakeServer();
    final bossPhone = TaskStore(await SharedPreferences.getInstance(), server, clock: clock);
    bossPhone.addTask(kind: TaskKind.seed, assigneeId: 'worker', day: day);
    await bossPhone.sync();

    SharedPreferences.setMockInitialValues({});
    final workerPhone = TaskStore(await SharedPreferences.getInstance(), server, clock: clock);
    await workerPhone.sync();
    expect(workerPhone.tasks, hasLength(1));

    workerPhone.finishTask(workerPhone.tasks.single.id);
    await workerPhone.sync();
    await bossPhone.sync();
    expect(bossPhone.tasks.single.doneAt, isNotNull);
  });

  test('a deletion reaches other phones', () async {
    final server = FakeServer();
    final one = TaskStore(await SharedPreferences.getInstance(), server, clock: clock);
    one.addTask(kind: TaskKind.seed, assigneeId: 'worker', day: day);
    await one.sync();

    SharedPreferences.setMockInitialValues({});
    final two = TaskStore(await SharedPreferences.getInstance(), server, clock: clock);
    await two.sync();

    one.deleteTask(one.tasks.single.id);
    await one.sync();
    await two.sync();
    expect(two.tasks, isEmpty);
  });

  test('a change not yet sent is not overwritten by the server', () async {
    final server = FakeServer();
    final store = await phone(server);
    store.addTask(kind: TaskKind.seed, assigneeId: 'worker', day: day);
    await store.sync();

    server.online = false;
    store.finishTask(store.tasks.single.id);
    await store.sync();
    server.online = true;
    await store.sync();
    expect(store.tasks.single.doneAt, isNotNull);
    expect(FarmTask.fromJson('x', 0, server.rows.values.single.data).doneAt, isNotNull);
  });

  test('demo tasks never duplicate, and never undo progress or a deletion', () async {
    final server = FakeServer();
    final one = await phone(server);
    one.seedDemoDay();
    await one.sync();
    expect(one.tasks, hasLength(demoDayTasks.length));
    final ids = one.tasks.map((t) => t.id).toList();
    one.finishTask(ids[0]);
    one.deleteTask(ids[1]);
    await one.sync();

    SharedPreferences.setMockInitialValues({});
    final two = await phone(server);
    two.seedDemoDay();
    await two.sync();
    expect(two.tasks, hasLength(demoDayTasks.length - 1));
    expect(two.tasks.singleWhere((t) => t.id == ids[0]).doneAt, isNotNull);
    expect(server.rows, hasLength(demoDayTasks.length));
  });

  test('a place location syncs', () async {
    final server = FakeServer();
    final one = await phone(server);
    one.savePlaceGps('barn', const GeoFix(33.1, -117.1));
    await one.sync();

    SharedPreferences.setMockInitialValues({});
    final two = TaskStore(await SharedPreferences.getInstance(), server, clock: clock);
    await two.sync();
    expect(two.place('barn')!.hasGps, isTrue);
  });
}
