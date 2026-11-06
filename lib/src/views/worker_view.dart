import 'dart:async';

import 'package:flutter/material.dart';

import '../location.dart';
import '../model.dart';
import '../task_rules.dart';
import '../task_store.dart';
import 'farm_map.dart';
import 'shared.dart';

/// Today's tasks, and nothing else to learn.
class WorkerView extends StatefulWidget {
  const WorkerView({super.key, required this.store, required this.location, required this.person});
  final TaskStore store;
  final LocationService location;
  final Person person;

  @override
  State<WorkerView> createState() => _WorkerViewState();
}

class _WorkerViewState extends State<WorkerView> {
  String? _placeFilter;
  String? _checking;
  late final Timer _tick = Timer.periodic(const Duration(seconds: 20), (_) => setState(() {}));

  @override
  void initState() {
    super.initState();
    _tick;
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  Future<void> _start(FarmTask task) async {
    final store = widget.store;
    final place = store.place(task.placeId);
    if (task.mustBeAtPlace && place != null && place.hasGps) {
      setState(() => _checking = task.id);
      final fix = await widget.location.current();
      if (!mounted) return;
      setState(() => _checking = null);
      if (!isAtPlace(place, fix)) {
        await _showGoThere(place);
        return;
      }
    }
    store.startTask(task.id);
  }

  Future<void> _showGoThere(Place place) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.directions_walk, size: 56),
          title: Text('Go to ${place.name}', textAlign: TextAlign.center),
          content: Icon(place.icon, size: 72, color: Theme.of(context).colorScheme.primary),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 64,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check, size: 36),
                label: const Text('OK', style: TextStyle(fontSize: 22)),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final now = store.now();
        final all = dayListFor(widget.person.id, store.tasks, now);
        final open = <String, int>{};
        for (final t in all) {
          if (t.placeId != null && isOpen(stateOf(t, now))) {
            open[t.placeId!] = (open[t.placeId!] ?? 0) + 1;
          }
        }
        final shown = _placeFilter == null ? all : all.where((t) => t.placeId == _placeFilter).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.person.name),
            actions: [SyncBadge(store)],
          ),
          body: Column(children: [
            FarmMap(
              pins: pinsFor(store.places, open),
              selected: _placeFilter,
              onPinTap: (id) => setState(() => _placeFilter = _placeFilter == id ? null : id),
            ),
            Expanded(
              child: shown.isEmpty
                  ? const _NothingToDo()
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: shown.length,
                      itemBuilder: (context, i) => _TaskCard(
                        task: shown[i],
                        place: store.place(shown[i].placeId),
                        now: now,
                        checking: _checking == shown[i].id,
                        onStart: () => _start(shown[i]),
                        onDone: () => store.finishTask(shown[i].id),
                      ),
                    ),
            ),
          ]),
        );
      },
    );
  }
}

class _NothingToDo extends StatelessWidget {
  const _NothingToDo();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.wb_sunny, size: 72, color: Color(0xFFC98A2F)),
          SizedBox(height: 8),
          Text('No tasks', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ]),
      );
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.place,
    required this.now,
    required this.checking,
    required this.onStart,
    required this.onDone,
  });

  final FarmTask task;
  final Place? place;
  final DateTime now;
  final bool checking;
  final VoidCallback onStart;
  final VoidCallback onDone;

  String? _timeHint(TaskState state) {
    if (state == TaskState.waiting) return clock(task.notBefore!);
    if (state == TaskState.ready && task.startBy != null) return '→ ${clock(task.startBy!)}';
    if (state == TaskState.inProgress && task.timeLimit != null) {
      final left = task.startedAt!.add(task.timeLimit!).difference(now);
      return '${left.inMinutes + 1} min';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = stateOf(task, now);
    final finished = !isOpen(state);
    final hint = _timeHint(state);
    return Opacity(
      opacity: finished ? .62 : 1,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              KindBadge(task.kind),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(task.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  if (place != null)
                    Row(children: [
                      Icon(place!.icon, size: 20),
                      const SizedBox(width: 4),
                      Flexible(child: Text(place!.name, style: const TextStyle(fontSize: 16))),
                      if (task.mustBeAtPlace) const Icon(Icons.my_location, size: 18),
                    ]),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                StateChip(state),
                if (hint != null)
                  Text(hint, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ]),
            ]),
            if (task.note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(task.note, style: const TextStyle(fontSize: 16)),
              ),
            if (canStart(state) || canFinish(state)) ...[
              const SizedBox(height: 12),
              _BigAction(
                canStart(state) ? Icons.play_arrow : Icons.check,
                canStart(state) ? 'Start' : 'Done',
                canStart(state) ? const Color(0xFF2E7D32) : const Color(0xFF1565C0),
                checking ? null : (canStart(state) ? onStart : onDone),
                busy: checking,
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

/// As per research:interaction/fitts-law-1954, the main action is the whole card's width and
/// 72 px tall, because bigger targets are hit faster and more reliably by gloved hands.
class _BigAction extends StatelessWidget {
  const _BigAction(this.icon, this.label, this.color, this.onPressed, {this.busy = false});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 72,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: onPressed,
          icon: busy
              ? const SizedBox.square(dimension: 30, child: CircularProgressIndicator(color: Colors.white))
              : Icon(icon, size: 40),
          label: Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        ),
      );
}
