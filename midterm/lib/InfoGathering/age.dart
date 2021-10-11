//code from: https://flutterforyou.com/how-to-add-date-picker-in-flutter/
//code from: https://viveky259259.medium.com/age-calculator-in-flutter-97853dc8486f

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midterm/Control/driver.dart';

class Age extends StatefulWidget {
  const Age({Key? key}) : super(key: key);

  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<Age> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late TextEditingController _dobController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _dobController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Age"),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 20.0),
              TextField(
                controller: _dobController,
                decoration: const InputDecoration(
                    labelText: "USER DOB",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Tap To Select DOB'),
                onTap: () async {
                  DateTime birthDate = await selectDate(context);
                  calculateAge(birthDate);
                },
              ),
              const SizedBox(height: 50.0),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));
                    setState(() {
                      register();
                    });
                  }
                },
                child: const Text('Submit'),
              )
            ])));
  }

  Future<void> register() async {
    try {
      final currentUserUid = _auth.currentUser!.uid;
      _db
          .collection("users")
          .doc(currentUserUid)
          .set({
            "age": _dobController.text,
          })
          .then((value) => (null))
          .onError((error, stackTrace) => (null));
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Age Updated")));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => AppDriver()));
  }

  void calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    num age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    _dobController.text = age.toString();
  }

  selectDate(BuildContext context) async {
    Completer completer = Completer();
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(DateTime.now().year + 100))
        .then((temp) {
      if (temp == null) return null;
      completer.complete(temp);
      setState(() {});
    });
    return completer.future;
  }
}
