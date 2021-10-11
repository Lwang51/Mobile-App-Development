import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midterm/Control/login.dart';
import 'package:midterm/InfoGathering/age.dart';
import 'package:midterm/InfoGathering/bio.dart';
import 'package:midterm/InfoGathering/hometown.dart';
import 'package:midterm/View/homepage.dart';

class AppDriver extends StatelessWidget {
  AppDriver({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: completeInformation(),
        builder: (context, snapshot) => _auth.currentUser == null
            ? const LoginPage()
            : snapshot.hasData && snapshot.data == 1
                ? const Bio()
                : snapshot.hasData && snapshot.data == 2
                    ? const Hometown()
                    : snapshot.hasData && snapshot.data == 3
                        ? const Age()
                        : const HomePage());
  }

  Future<int> completeInformation() async {
    final currentUserUid = _auth.currentUser!.uid;
    final DocumentSnapshot db =
        await _db.collection('users').doc(currentUserUid).get();
    if ((db.data() as dynamic)['bio'] != "") {
      if ((db.data() as dynamic)['hometown'] != "") {
        if ((db.data() as dynamic)['age'] != "") {
          return 0;
        } else {
          return 3;
        }
      } else {
        return 2;
      }
    } else {
      return 1;
    }
  }
}
