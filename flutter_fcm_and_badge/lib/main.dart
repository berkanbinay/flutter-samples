import 'package:flutter/material.dart';

import 'feature/view/home_page.dart';
import 'project/manager/firebase_manager/firebase_manager.dart';

void main() {
  _initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseManager.instance.init();
}
