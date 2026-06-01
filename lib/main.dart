import 'package:flutter/material.dart';
import 'package:krakflow_flutter/services/notification_service.dart';
import 'widgets/task_list_screen.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await Hive.initFlutter();
  await Hive.openBox("tasks");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TaskListScreen());
  }
}
