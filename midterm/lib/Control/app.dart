import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:midterm/Control/driver.dart';
import 'package:midterm/View/error.dart';
import 'package:midterm/View/loading.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialize = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: FutureBuilder(
                future: _initialize,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const ErrorPage();
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AppDriver();
                  } else {
                    return const LoadingPage();
                  }
                })));
  }
}
