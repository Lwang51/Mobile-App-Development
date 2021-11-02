import 'package:chatterbox/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
        value: FirebaseAuth.instance.authStateChanges(),
        initialData: null,
        child: const MaterialApp(
          title: 'MAD Assignment 3',
          debugShowCheckedModeBanner: false,
          home: AppDriver(),
        ));
  }
}
