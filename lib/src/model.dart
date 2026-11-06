import 'package:flutter/material.dart';

enum Role { admin, worker }

class Person {
  const Person({required this.id, required this.name, required this.role});
  final String id;
  final String name;
  final Role role;
}

/// What the work is. Icon and colour carry the meaning; the label is a language aid.
enum TaskKind {
  seed('Seed', Icons.grass, Color(0xFF558B2F)),
  water('Water', Icons.water_drop, Color(0xFF1E88E5)),
  measure('Measure', Icons.speed, Color(0xFF3949AB)),
  trash('Trash', Icons.delete, Color(0xFF616161)),
  harvest('Harvest', Icons.agriculture, Color(0xFFEF6C00)),
  feed('Feed', Icons.pets, Color(0xFF8D6E63)),
  repair('Fix', Icons.build, Color(0xFF546E7A)),
  clean('Clean', Icons.cleaning_services, Color(0xFF00897B)),
  carry('Carry', Icons.local_shipping, Color(0xFF6D4C41)),
  other('Other', Icons.task_alt, Color(0xFF5E35B1));

  const TaskKind(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// A spot on the farm. [mapX] and [mapY] place it on the illustrated map (0 to 1); GPS is
/// separate because the illustration isn't to scale. NFC tags will attach here.
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.icon,
    required this.mapX,
    required this.mapY,
    this.lat,
    this.lng,
    this.radiusM = 75,
    this.updatedAt = 0,
  });

  final String id;
  final String name;
  final IconData icon;
  final double mapX;
  final double mapY;
  final double? lat;
  final double? lng;
  final double radiusM;
  final int updatedAt;

  bool get hasGps => lat != null && lng != null;

  Place withGps(double lat, double lng, double radiusM, int updatedAt) => Place(
        id: id,
        name: name,
        icon: icon,
        mapX: mapX,
        mapY: mapY,
        lat: lat,
        lng: lng,
        radiusM: radiusM,
        updatedAt: updatedAt,
      );
}

class GeoFix {
  const GeoFix(this.lat, this.lng, {this.accuracyM = 0});
  final double lat;
  final double lng;
  final double accuracyM;
}

class FarmTask {
  const FarmTask({
    required this.id,
    required this.kind,
    required this.title,
    required this.assigneeId,
    required this.day,
    required this.updatedAt,
    this.note = '',
    this.placeId,
    this.mustBeAtPlace = false,
    this.notBefore,
    this.startBy,
    this.expiresAt,
    this.timeLimit,
    this.startedAt,
    this.doneAt,
  });

  final String id;
  final TaskKind kind;
  final String title;
  final String note;
  final String assigneeId;

  /// The day the work is planned for, at local midnight.
  final DateTime day;
  final String? placeId;
  final bool mustBeAtPlace;
  final DateTime? notBefore;
  final DateTime? startBy;
  final DateTime? expiresAt;
  final Duration? timeLimit;
  final DateTime? startedAt;
  final DateTime? doneAt;
  final int updatedAt;

  FarmTask started(DateTime at) => _progress(at, doneAt, at);
  FarmTask finished(DateTime at) => _progress(startedAt ?? at, at, at);

  FarmTask _progress(DateTime? started, DateTime? done, DateTime at) => FarmTask(
        id: id,
        kind: kind,
        title: title,
        note: note,
        assigneeId: assigneeId,
        day: day,
        placeId: placeId,
        mustBeAtPlace: mustBeAtPlace,
        notBefore: notBefore,
        startBy: startBy,
        expiresAt: expiresAt,
        timeLimit: timeLimit,
        startedAt: started,
        doneAt: done,
        updatedAt: at.millisecondsSinceEpoch,
      );

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'title': title,
        'note': note,
        'assigneeId': assigneeId,
        'day': day.toIso8601String(),
        'placeId': placeId,
        'mustBeAtPlace': mustBeAtPlace,
        'notBefore': notBefore?.toIso8601String(),
        'startBy': startBy?.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'timeLimitMin': timeLimit?.inMinutes,
        'startedAt': startedAt?.toIso8601String(),
        'doneAt': doneAt?.toIso8601String(),
      };

  factory FarmTask.fromJson(String id, int updatedAt, Map<String, dynamic> json) {
    DateTime? time(String key) =>
        json[key] == null ? null : DateTime.parse(json[key] as String);
    final limit = json['timeLimitMin'] as int?;
    return FarmTask(
      id: id,
      updatedAt: updatedAt,
      kind: TaskKind.values.asNameMap()[json['kind']] ?? TaskKind.other,
      title: json['title'] as String,
      note: json['note'] as String? ?? '',
      assigneeId: json['assigneeId'] as String,
      day: DateTime.parse(json['day'] as String),
      placeId: json['placeId'] as String?,
      mustBeAtPlace: json['mustBeAtPlace'] as bool? ?? false,
      notBefore: time('notBefore'),
      startBy: time('startBy'),
      expiresAt: time('expiresAt'),
      timeLimit: limit == null ? null : Duration(minutes: limit),
      startedAt: time('startedAt'),
      doneAt: time('doneAt'),
    );
  }
}

/// The proof-of-concept's people, until Google sign-in tells them apart.
const admin = Person(id: 'admin', name: 'Admin', role: Role.admin);
const worker = Person(id: 'worker', name: 'Worker', role: Role.worker);
const demoPeople = [admin, worker];
const demoWorkers = [worker];

const demoPlaces = [
  Place(id: 'north-field', name: 'North Field', icon: Icons.grass, mapX: 0.24, mapY: 0.28),
  Place(id: 'orchard', name: 'Orchard', icon: Icons.park, mapX: 0.76, mapY: 0.24),
  Place(id: 'barn', name: 'Barn', icon: Icons.warehouse, mapX: 0.52, mapY: 0.56),
  Place(id: 'greenhouse', name: 'Greenhouse', icon: Icons.yard, mapX: 0.17, mapY: 0.76),
  Place(id: 'pasture', name: 'Pasture', icon: Icons.fence, mapX: 0.80, mapY: 0.76),
];

/// Seeded every day so the demo always has work on landing, in this order.
const demoDayTasks = [
  (key: '1-irrigate', kind: TaskKind.water, title: 'Irrigate crops', placeId: 'north-field', limit: null),
  (key: '2-moisture', kind: TaskKind.measure, title: 'Measure moisture', placeId: 'orchard', limit: Duration(minutes: 30)),
  (key: '3-trash', kind: TaskKind.trash, title: 'Take the trash out', placeId: 'barn', limit: null),
];
