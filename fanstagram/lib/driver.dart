import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanstagram/Pages/adminpage.dart';
import 'package:fanstagram/Pages/homepage.dart';
import 'package:fanstagram/Pages/login.dart';
import 'package:fanstagram/UI/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDriver extends StatelessWidget {
  AppDriver({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _db.collection('users').doc(_auth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (_auth.currentUser == null) {
            return const LoginPage();
          } else if (!snapshot.hasData) {
            return const ErrorPage();
          } else {
            var userDocument = snapshot.data;
            if ((userDocument as dynamic)["isAdmin"] == null) {
              return HomePage();
            } else if ((userDocument as dynamic)["isAdmin"] == true) {
              return AdminHomePage();
            }
          }
          return const ErrorPage();
        });
  }
}

/*
FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).isAdmin(),
        builder: (context, snapshot) => _auth.currentUser == null
            ? const LoginPage()
            : snapshot.hasData && snapshot.data == true // if isAdmin() is true
                ? AdminHomePage() // return Admin
                : HomePage() // else if false, return UserTab
        );
*/