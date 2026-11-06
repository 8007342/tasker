import 'dart:convert';

import 'package:http/http.dart' as http;

/// One stored thing, as the server's `records` table holds it.
class SyncRecord {
  const SyncRecord({
    required this.kind,
    required this.id,
    required this.updatedAt,
    required this.data,
    this.deleted = false,
  });

  final String kind;
  final String id;
  final int updatedAt;
  final bool deleted;
  final Map<String, dynamic> data;

  String get key => '$kind/$id';

  Map<String, dynamic> toJson() =>
      {'kind': kind, 'id': id, 'updatedAt': updatedAt, 'deleted': deleted, 'data': data};

  factory SyncRecord.fromJson(Map<String, dynamic> json) => SyncRecord(
        kind: json['kind'] as String,
        id: json['id'] as String,
        updatedAt: json['updatedAt'] as int,
        deleted: json['deleted'] as bool? ?? false,
        data: json['data'] as Map<String, dynamic>,
      );
}

abstract class SyncApi {
  /// Sends [changes] and returns everything the server holds. Throws when it can't be reached.
  Future<List<SyncRecord>> sync(List<SyncRecord> changes);
}

class HttpSyncApi implements SyncApi {
  HttpSyncApi([http.Client? client]) : _client = client ?? http.Client();
  final http.Client _client;

  @override
  Future<List<SyncRecord>> sync(List<SyncRecord> changes) async {
    var response = await _post(changes);
    // Sync is safe to repeat, so ride out a momentary server hiccup without showing anything.
    if (response.statusCode == 502 || response.statusCode == 503) {
      response = await _post(changes);
    }
    if (response.statusCode != 200) {
      throw http.ClientException('sync returned ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return [
      for (final r in body['records'] as List) SyncRecord.fromJson(r as Map<String, dynamic>),
    ];
  }

  Future<http.Response> _post(List<SyncRecord> changes) => _client
      .post(
        Uri.base.resolve('/api/sync'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'changes': changes}),
      )
      .timeout(const Duration(seconds: 20));
}
