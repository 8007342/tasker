import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'model.dart';
import 'sync_api.dart';
import 'task_rules.dart';

enum SyncStatus { synced, waiting }

/// The app's one controller. Every change lands on the phone first, as per
/// research:interaction/response-time-limits-nielsen-1993, because a tap must answer in about
/// 0.1 s and the network can't promise that. The outbox then carries it to the server whenever
/// the server can be reached.
class TaskStore extends ChangeNotifier {
  TaskStore(this._prefs, this._api, {DateTime Function()? clock})
      : now = clock ?? DateTime.now {
    _load();
  }

  static const _key = 'tasker.v1';

  final SharedPreferences _prefs;
  final SyncApi _api;
  final DateTime Function() now;

  final Map<String, FarmTask> _tasks = {};
  final Map<String, Place> _places = {for (final p in demoPlaces) p.id: p};
  final Map<String, SyncRecord> _outbox = {};
  Future<void>? _running;
  bool _syncAgain = false;
  bool _reachedServer = false;
  Timer? _timer;

  Iterable<FarmTask> get tasks => _tasks.values;
  List<Place> get places => _places.values.toList();
  Place? place(String? id) => _places[id];
  int get unsent => _outbox.length;
  SyncStatus get status =>
      _outbox.isEmpty && _reachedServer ? SyncStatus.synced : SyncStatus.waiting;

  void startAutoSync({Duration every = const Duration(seconds: 5)}) {
    unawaited(sync());
    _timer ??= Timer.periodic(every, (_) => sync());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Puts today's demo tasks on the list. Ids are fixed per day and the timestamp is 0, so every
  /// phone seeds the same tasks, and any real progress or deletion on the server wins.
  void seedDemoDay() {
    final today = dayOf(now());
    final stamp = '${today.year}-${today.month}-${today.day}';
    var added = false;
    for (final seed in demoDayTasks) {
      final id = 'demo-$stamp-${seed.key}';
      if (_tasks.containsKey(id)) continue;
      final task = FarmTask(
        id: id,
        kind: seed.kind,
        title: seed.title,
        assigneeId: worker.id,
        day: today,
        placeId: seed.placeId,
        timeLimit: seed.limit,
        updatedAt: 0,
      );
      _tasks[id] = task;
      _outbox['task/$id'] = SyncRecord(kind: 'task', id: id, updatedAt: 0, data: task.toJson());
      added = true;
    }
    if (added) {
      notifyListeners();
      _save();
    }
  }

  void addTask({
    required TaskKind kind,
    required String assigneeId,
    required DateTime day,
    String? title,
    String note = '',
    String? placeId,
    bool mustBeAtPlace = false,
    DateTime? notBefore,
    DateTime? startBy,
    DateTime? expiresAt,
    Duration? timeLimit,
  }) {
    final trimmed = title?.trim() ?? '';
    final task = FarmTask(
      id: const Uuid().v4(),
      kind: kind,
      title: trimmed.isEmpty ? kind.label : trimmed,
      note: note.trim(),
      assigneeId: assigneeId,
      day: day,
      placeId: placeId,
      mustBeAtPlace: mustBeAtPlace,
      notBefore: notBefore,
      startBy: startBy,
      expiresAt: expiresAt,
      timeLimit: timeLimit,
      updatedAt: now().millisecondsSinceEpoch,
    );
    _putTask(task);
  }

  void startTask(String id) {
    final task = _tasks[id];
    if (task != null) _putTask(task.started(now()));
  }

  void finishTask(String id) {
    final task = _tasks[id];
    if (task != null) _putTask(task.finished(now()));
  }

  void deleteTask(String id) {
    if (_tasks.remove(id) == null) return;
    _commit(SyncRecord(
      kind: 'task',
      id: id,
      updatedAt: now().millisecondsSinceEpoch,
      deleted: true,
      data: const {},
    ));
  }

  void savePlaceGps(String id, GeoFix fix) {
    final place = _places[id];
    if (place == null) return;
    final at = now().millisecondsSinceEpoch;
    _places[id] = place.withGps(fix.lat, fix.lng, place.radiusM, at);
    _commit(SyncRecord(
      kind: 'place',
      id: id,
      updatedAt: at,
      data: {'lat': fix.lat, 'lng': fix.lng, 'radiusM': place.radiusM},
    ));
  }

  void _putTask(FarmTask task) {
    _tasks[task.id] = task;
    _commit(SyncRecord(kind: 'task', id: task.id, updatedAt: task.updatedAt, data: task.toJson()));
  }

  void _commit(SyncRecord change) {
    _outbox[change.key] = change;
    notifyListeners();
    _save();
    unawaited(sync());
  }

  /// Sends what's waiting and takes what others changed. Safe to call at any time: a call made
  /// during a sync joins it and adds one more pass. Failing just means trying again later.
  Future<void> sync() {
    if (_running != null) {
      _syncAgain = true;
      return _running!;
    }
    return _running = _syncPasses().whenComplete(() => _running = null);
  }

  Future<void> _syncPasses() async {
    do {
      _syncAgain = false;
      await _syncOnce();
    } while (_syncAgain);
  }

  Future<void> _syncOnce() async {
    try {
      final sent = _outbox.values.toList();
      final records = await _api.sync(sent);
      for (final change in sent) {
        // A newer change made while this one travelled stays queued.
        if (_outbox[change.key]?.updatedAt == change.updatedAt) _outbox.remove(change.key);
      }
      for (final record in records) {
        if (!_outbox.containsKey(record.key)) _apply(record);
      }
      _reachedServer = true;
      _save();
    } catch (error) {
      _reachedServer = false;
      debugPrint('sync: will retry ($error)');
    }
    notifyListeners();
  }

  /// Newest write wins. Workers only touch progress and the admin only creates and deletes, so
  /// two people rarely change the same task.
  void _apply(SyncRecord record) {
    if (record.kind == 'task') {
      final mine = _tasks[record.id];
      if (mine != null && mine.updatedAt > record.updatedAt) return;
      if (record.deleted) {
        _tasks.remove(record.id);
      } else {
        _tasks[record.id] = FarmTask.fromJson(record.id, record.updatedAt, record.data);
      }
    } else if (record.kind == 'place' && !record.deleted) {
      final place = _places[record.id];
      if (place == null || place.updatedAt > record.updatedAt) return;
      _places[record.id] = place.withGps(
        (record.data['lat'] as num).toDouble(),
        (record.data['lng'] as num).toDouble(),
        (record.data['radiusM'] as num).toDouble(),
        record.updatedAt,
      );
    }
  }

  void _save() {
    final state = {
      'records': [
        for (final t in _tasks.values)
          SyncRecord(kind: 'task', id: t.id, updatedAt: t.updatedAt, data: t.toJson()),
        for (final p in _places.values)
          if (p.hasGps)
            SyncRecord(
              kind: 'place',
              id: p.id,
              updatedAt: p.updatedAt,
              data: {'lat': p.lat, 'lng': p.lng, 'radiusM': p.radiusM},
            ),
      ],
      'outbox': _outbox.values.toList(),
    };
    unawaited(_prefs.setString(_key, jsonEncode(state)));
  }

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    final state = jsonDecode(raw) as Map<String, dynamic>;
    for (final r in state['records'] as List) {
      _apply(SyncRecord.fromJson(r as Map<String, dynamic>));
    }
    for (final r in state['outbox'] as List) {
      final change = SyncRecord.fromJson(r as Map<String, dynamic>);
      _outbox[change.key] = change;
    }
  }
}
