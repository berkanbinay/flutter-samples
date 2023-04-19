import 'package:flutter/material.dart';

import 'feature/view/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
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
