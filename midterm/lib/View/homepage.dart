//code from: https://firebase.flutter.dev/docs/firestore/usage/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midterm/Control/driver.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  CustomerView createState() => CustomerView();
}

class CustomerView extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _signOut(context),
          );
        },
        tooltip: 'Log Out',
        child: const Icon(Icons.logout),
      ),
    );
  }

  Widget _signOut(BuildContext context) {
    return AlertDialog(
      title: const Text('Do you want to log out?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).clearSnackBars();
            await _auth.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User logged out.')));
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (con) => AppDriver()));
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}
