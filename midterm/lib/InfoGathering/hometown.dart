import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midterm/Control/driver.dart';

class Hometown extends StatefulWidget {
  const Hometown({Key? key}) : super(key: key);

  @override
  _HometownPageState createState() => _HometownPageState();
}

class _HometownPageState extends State<Hometown> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late TextEditingController _hometownController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _hometownController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _hometownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Bio"),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: true,
                controller: _hometownController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your hometown';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "USER HOMETOWN",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Hometown'),
              ),
              const SizedBox(height: 20.0),
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
            "hometown": _hometownController.text,
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
        .showSnackBar(const SnackBar(content: Text("Hometown Updated")));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => AppDriver()));
  }
}
