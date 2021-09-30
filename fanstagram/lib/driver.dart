import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanstagram/Pages/adminpage.dart';
import 'package:fanstagram/Pages/homepage.dart';
import 'package:fanstagram/Pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDriver extends StatelessWidget {
  AppDriver({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isAdmin(),
        builder: (context, snapshot) => _auth.currentUser == null
            ? const LoginPage()
            : snapshot.hasData && snapshot.data == true
                ? const AdminHomePage()
                : const HomePage());
  }

  Future<bool> isAdmin() async {
    final currentUserUid = _auth.currentUser!.uid;
    final DocumentSnapshot db =
        await _db.collection('users').doc(currentUserUid).get();
    return (db.data() as dynamic)['isAdmin'];
  }
}

/*
_auth.currentUser == null
        ? const LoginPage()
        : _db
                .collection("users")
                .doc(_auth.currentUser!.uid).get(["isAdmin"]) == true
            ? AdminHomePage()
            : HomePage();
}

StreamBuilder(
        stream: _db.collection('users').doc(_auth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (_auth.currentUser == null) {
            return const LoginPage();
          } else if (!snapshot.hasData) {
            return const ErrorPage();
          } else {
            if (_auth.currentUser!.uid.contains("isAdmin")) {
              return HomePage();
            } else{
              return AdminHomePage();
            }
          }
        });
*/