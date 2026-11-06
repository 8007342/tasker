import 'package:flutter/material.dart';

import '../model.dart';
import '../task_rules.dart';
import '../task_store.dart';

/// Every state has its own icon as well as its own colour, so neither reading nor colour vision
/// is needed to tell them apart.
({IconData icon, Color color, String label}) styleOf(TaskState s) => switch (s) {
      TaskState.waiting => (icon: Icons.schedule, color: const Color(0xFF5F6B7A), label: 'Wait'),
      TaskState.ready => (icon: Icons.play_circle, color: const Color(0xFF2E7D32), label: 'To do'),
      TaskState.inProgress => (icon: Icons.autorenew, color: const Color(0xFF1565C0), label: 'Working'),
      TaskState.overdue => (icon: Icons.hourglass_bottom, color: const Color(0xFFD84315), label: 'Late'),
      TaskState.done => (icon: Icons.check_circle, color: const Color(0xFF2E7D32), label: 'Done'),
      TaskState.missed => (icon: Icons.event_busy, color: const Color(0xFF8E2A2A), label: 'Missed'),
      TaskState.expired => (icon: Icons.block, color: const Color(0xFF6B6B6B), label: 'Expired'),
    };

String clock(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// Round icon showing what kind of work a task is.
class KindBadge extends StatelessWidget {
  const KindBadge(this.kind, {super.key, this.size = 56});
  final TaskKind kind;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: kind.color, shape: BoxShape.circle),
        child: Icon(kind.icon, color: Colors.white, size: size * .56),
      );
}

class StateChip extends StatelessWidget {
  const StateChip(this.state, {super.key});
  final TaskState state;

  @override
  Widget build(BuildContext context) {
    final style = styleOf(state);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(style.icon, color: style.color, size: 22),
      const SizedBox(width: 5),
      Text(style.label, style: TextStyle(color: style.color, fontWeight: FontWeight.w700)),
    ]);
  }
}

/// Answers "did it save?": a tick when the server has everything, a cloud with a count when
/// changes are safe on the phone and waiting for signal.
class SyncBadge extends StatelessWidget {
  const SyncBadge(this.store, {super.key});
  final TaskStore store;

  @override
  Widget build(BuildContext context) {
    final synced = store.status == SyncStatus.synced;
    return Semantics(
      label: synced ? 'Everything is saved' : '${store.unsent} waiting for signal',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Icon(synced ? Icons.cloud_done : Icons.cloud_off, color: Colors.white),
          if (store.unsent > 0) ...[
            const SizedBox(width: 4),
            Text('${store.unsent}', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ]),
      ),
    );
  }
}
