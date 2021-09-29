import 'package:fanstagram/Pages/splash.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 1 App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const Splash(title: "Splash Screen"),
    );
  }
}
