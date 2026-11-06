import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/brand.dart';
import 'src/location.dart';
import 'src/sync_api.dart';
import 'src/task_store.dart';
import 'src/views/landing_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final store = TaskStore(prefs, HttpSyncApi())
    ..seedDemoDay()
    ..startAutoSync();
  runApp(TaskerApp(store: store, location: DeviceLocation()));
}

class TaskerApp extends StatelessWidget {
  const TaskerApp({super.key, required this.store, required this.location});
  final TaskStore store;
  final LocationService location;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Tasker',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: LandingView(store: store, location: location),
      );
}
