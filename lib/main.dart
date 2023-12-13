// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:melakaaa/review_list.dart';
import 'package:melakaaa/review.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review App',
      initialRoute: '/',
      routes: {
        '/': (context) => ReviewScreen(),
        '/review_list': (context) => ReviewListScreen(),
      },
    );
  }
}
