import 'dart:async';

import 'package:flutter/material.dart';

import '../location.dart';
import '../model.dart';
import '../task_rules.dart';
import '../task_store.dart';
import 'farm_map.dart';
import 'shared.dart';
import 'task_form.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key, required this.store, required this.location});
  final TaskStore store;
  final LocationService location;

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int _dayOffset = 0;
  String? _placeFilter;
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

  void _openForm() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TaskFormPage(store: widget.store)),
      );

  void _openPlaces() => showModalBottomSheet(
        context: context,
        builder: (_) => _PlacesSheet(store: widget.store, location: widget.location),
      );

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final now = store.now();
        final day = dayOf(now).add(Duration(days: _dayOffset));
        final ofDay = store.tasks.where((t) => t.day.isAtSameMomentAs(day)).toList()
          ..sort((a, b) => a.id.compareTo(b.id));
        final open = <String, int>{};
        for (final t in ofDay) {
          if (t.placeId != null && isOpen(stateOf(t, now))) {
            open[t.placeId!] = (open[t.placeId!] ?? 0) + 1;
          }
        }
        final shown = _placeFilter == null ? ofDay : ofDay.where((t) => t.placeId == _placeFilter).toList();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin'),
            actions: [
              IconButton(tooltip: 'Places', icon: const Icon(Icons.pin_drop), onPressed: _openPlaces),
              SyncBadge(store),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openForm,
            icon: const Icon(Icons.add),
            label: const Text('New task'),
          ),
          body: Column(children: [
            FarmMap(
              pins: pinsFor(store.places, open),
              selected: _placeFilter,
              onPinTap: (id) => setState(() => _placeFilter = _placeFilter == id ? null : id),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Today')),
                  ButtonSegment(value: 1, label: Text('Tomorrow')),
                ],
                selected: {_dayOffset},
                onSelectionChanged: (s) => setState(() => _dayOffset = s.first),
              ),
            ),
            Expanded(
              child: shown.isEmpty
                  ? const Center(child: Text('No tasks yet', style: TextStyle(fontSize: 18)))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
                      children: [
                        for (final person in demoWorkers)
                          ..._section(person, shown, now),
                      ],
                    ),
            ),
          ]),
        );
      },
    );
  }

  List<Widget> _section(Person person, List<FarmTask> tasks, DateTime now) {
    final theirs = tasks.where((t) => t.assigneeId == person.id).toList();
    if (theirs.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(person.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      for (final task in theirs)
        Card(
          child: ListTile(
            leading: KindBadge(task.kind, size: 44),
            title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(_summary(task)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              StateChip(stateOf(task, now)),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => widget.store.deleteTask(task.id),
              ),
            ]),
          ),
        ),
    ];
  }

  String _summary(FarmTask t) => [
        if (widget.store.place(t.placeId) case final place?) place.name,
        if (t.mustBeAtPlace) 'must be there',
        if (t.notBefore != null) 'from ${clock(t.notBefore!)}',
        if (t.startBy != null) 'start by ${clock(t.startBy!)}',
        if (t.timeLimit != null) '${t.timeLimit!.inMinutes} min limit',
        if (t.expiresAt != null) 'expires ${clock(t.expiresAt!)}',
      ].join(' · ');
}

/// Saves GPS by standing at a place: the illustrated map isn't to scale, so tapping it wouldn't
/// give a position good enough to check a worker against.
class _PlacesSheet extends StatefulWidget {
  const _PlacesSheet({required this.store, required this.location});
  final TaskStore store;
  final LocationService location;

  @override
  State<_PlacesSheet> createState() => _PlacesSheetState();
}

class _PlacesSheetState extends State<_PlacesSheet> {
  String? _busy;
  String? _failed;

  Future<void> _save(Place place) async {
    setState(() {
      _busy = place.id;
      _failed = null;
    });
    final fix = await widget.location.current();
    if (!mounted) return;
    if (fix != null) widget.store.savePlaceGps(place.id, fix);
    setState(() {
      _busy = null;
      _failed = fix == null ? place.id : null;
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListView(shrinkWrap: true, children: [
          const ListTile(title: Text('Stand at a place, then save its location')),
          for (final place in widget.store.places)
            ListTile(
              leading: Icon(place.icon),
              title: Text(place.name),
              subtitle: Text(_failed == place.id
                  ? 'Could not get a location'
                  : place.hasGps
                      ? 'Location saved'
                      : 'No location yet'),
              trailing: _busy == place.id
                  ? const CircularProgressIndicator()
                  : TextButton.icon(
                      onPressed: () => _save(place),
                      icon: const Icon(Icons.my_location),
                      label: const Text('Save here'),
                    ),
            ),
        ]),
      );
}
