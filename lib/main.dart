import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_db/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hive DB",
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent)),
      home: HomePage(),
    );
  }
}
