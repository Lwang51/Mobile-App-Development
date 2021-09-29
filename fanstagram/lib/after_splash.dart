import 'package:fanstagram/UI/error.dart';
import 'package:fanstagram/UI/loading.dart';
import 'package:fanstagram/driver.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AfterSplash extends StatefulWidget {
  const AfterSplash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AfterSplash();
}

class _AfterSplash extends State<AfterSplash> {
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
