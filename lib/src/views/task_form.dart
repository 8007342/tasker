import 'package:flutter/material.dart';

import '../model.dart';
import '../task_rules.dart';
import '../task_store.dart';
import 'shared.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key, required this.store});
  final TaskStore store;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _title = TextEditingController();
  final _note = TextEditingController();
  TaskKind _kind = TaskKind.seed;
  String _assignee = demoWorkers.first.id;
  String? _placeId;
  int _dayOffset = 0;
  bool _mustBeThere = false;
  TimeOfDay? _notBefore;
  TimeOfDay? _startBy;
  int? _limitMin;
  int? _ttlHours;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  DateTime get _day => dayOf(widget.store.now()).add(Duration(days: _dayOffset));

  DateTime? _at(TimeOfDay? t) =>
      t == null ? null : _day.add(Duration(hours: t.hour, minutes: t.minute));

  void _save() {
    final notBefore = _at(_notBefore), startBy = _at(_startBy);
    if (notBefore != null && startBy != null && !startBy.isAfter(notBefore)) {
      setState(() => _error = '"Start by" must be after "Not before"');
      return;
    }
    widget.store.addTask(
      kind: _kind,
      title: _title.text,
      note: _note.text,
      assigneeId: _assignee,
      day: _day,
      placeId: _placeId,
      mustBeAtPlace: _mustBeThere,
      notBefore: notBefore,
      startBy: startBy,
      timeLimit: _limitMin == null ? null : Duration(minutes: _limitMin!),
      expiresAt: _ttlHours == null
          ? null
          : expiryFrom(_day, widget.store.now(), Duration(hours: _ttlHours!)),
    );
    Navigator.pop(context);
  }

  Future<void> _pick(TimeOfDay? current, void Function(TimeOfDay) set) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.fromDateTime(widget.store.now()),
    );
    if (picked != null) setState(() => set(picked));
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.store.place(_placeId);
    final canRequireGps = place?.hasGps ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('New task')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 64,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check, size: 30),
              label: const Text('Save and assign', style: TextStyle(fontSize: 20)),
            ),
          ),
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final kind in TaskKind.values)
            ChoiceChip(
              avatar: Icon(kind.icon, color: kind.color),
              label: Text(kind.label),
              selected: _kind == kind,
              onSelected: (_) => setState(() => _kind = kind),
            ),
        ]),
        const SizedBox(height: 16),
        TextField(
          controller: _title,
          decoration: InputDecoration(
            labelText: 'Title (optional)',
            hintText: _kind.label,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _note,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Note (optional)', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _assignee,
          decoration: const InputDecoration(labelText: 'Worker', border: OutlineInputBorder()),
          items: [
            for (final p in demoWorkers) DropdownMenuItem(value: p.id, child: Text(p.name)),
          ],
          onChanged: (v) => setState(() => _assignee = v!),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          initialValue: _placeId,
          decoration: const InputDecoration(labelText: 'Place', border: OutlineInputBorder()),
          items: [
            const DropdownMenuItem(value: null, child: Text('Anywhere')),
            for (final p in widget.store.places) DropdownMenuItem(value: p.id, child: Text(p.name)),
          ],
          onChanged: (v) => setState(() {
            _placeId = v;
            if (!(widget.store.place(v)?.hasGps ?? false)) _mustBeThere = false;
          }),
        ),
        const SizedBox(height: 12),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('Today')),
            ButtonSegment(value: 1, label: Text('Tomorrow')),
          ],
          selected: {_dayOffset},
          onSelectionChanged: (s) => setState(() => _dayOffset = s.first),
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          title: const Text('Rules (optional)'),
          tilePadding: EdgeInsets.zero,
          children: [
            SwitchListTile(
              title: const Text('Must be at the place to start'),
              subtitle: Text(canRequireGps
                  ? 'Checked by GPS'
                  : place == null
                      ? 'Pick a place first'
                      : 'Save this place\'s location first (pin icon on the Admin screen)'),
              value: _mustBeThere,
              onChanged: canRequireGps ? (v) => setState(() => _mustBeThere = v) : null,
            ),
            _TimeRow('Not before', _notBefore, () => _pick(_notBefore, (t) => _notBefore = t),
                () => setState(() => _notBefore = null)),
            _TimeRow('Must start by', _startBy, () => _pick(_startBy, (t) => _startBy = t),
                () => setState(() => _startBy = null)),
            const SizedBox(height: 8),
            _Choice('Time limit once started', _limitMin,
                const {15: '15 min', 30: '30 min', 60: '1 hour', 120: '2 hours', 240: '4 hours'},
                (v) => setState(() => _limitMin = v)),
            const SizedBox(height: 12),
            _Choice('Expires after', _ttlHours,
                const {2: '2 hours', 8: '8 hours', 24: '1 day', 72: '3 days'},
                (v) => setState(() => _ttlHours = v)),
            const SizedBox(height: 12),
          ],
        ),
        if (_error != null)
          Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ]),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow(this.label, this.value, this.onPick, this.onClear);
  final String label;
  final TimeOfDay? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(label),
        subtitle: Text(value == null
            ? 'None'
            : clock(DateTime(2000, 1, 1, value!.hour, value!.minute))),
        onTap: onPick,
        trailing: value == null
            ? const Icon(Icons.schedule)
            : IconButton(icon: const Icon(Icons.close), tooltip: 'Clear', onPressed: onClear),
      );
}

class _Choice extends StatelessWidget {
  const _Choice(this.label, this.value, this.options, this.onChanged);
  final String label;
  final int? value;
  final Map<int, String> options;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<int?>(
        initialValue: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: [
          const DropdownMenuItem(value: null, child: Text('None')),
          for (final o in options.entries) DropdownMenuItem(value: o.key, child: Text(o.value)),
        ],
        onChanged: onChanged,
      );
}
