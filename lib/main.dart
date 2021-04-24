import 'package:flutter/material.dart';
import 'package:workout_guide/screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Workout guide",
      home: AuthScreen(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.deepOrange,
      ),
    );
  }
}
