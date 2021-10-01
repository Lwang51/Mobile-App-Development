//code from: https://appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
//code from: https://www.geeksforgeeks.org/flutter-read-and-write-data-on-firebase/
//code from: https://firebase.flutter.dev/docs/firestore/usage/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanstagram/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('Messages')
      .orderBy('postDateTime', descending: true)
      .snapshots(includeMetadataChanges: true);

  final TextEditingController _textController = TextEditingController();
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Scaffold(
              body: StreamBuilder<QuerySnapshot>(
            stream: _messageStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['Text']),
                    subtitle: Text(data['postDateTime']),
                  );
                }).toList(),
              );
            },
          )),
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                _signOut(context);
              },
              tooltip: 'Sign Out',
              child: const Icon(Icons.logout),
            )),
        Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () {
                _newPost(context);
              },
              tooltip: 'New Posts',
              child: const Icon(Icons.add),
            )),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you want to log out?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  await _auth.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User logged out.')));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (con) => AppDriver()));
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
        });
  }

  Future<void> _newPost(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('What Should The New Post Be?'),
            content: TextField(
              autocorrect: true,
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
              controller: _textController,
              decoration: const InputDecoration(hintText: "New Post Message"),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () {
                    _textController.clear();
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.red.shade200,
                  )),
              TextButton(
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      FirebaseFirestore.instance.collection("Messages").add({
                        'Text': message,
                        "postDateTime": DateFormat("yyyy-MM-dd hh:mm:ss")
                            .format(DateTime.now())
                      });
                      _textController.clear();
                      Navigator.pop(context);
                    });
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.lightBlue.shade200,
                  )),
            ],
          );
        });
  }
}

/* old code
import 'package:fanstagram/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminHomePage> {
  late TextEditingController _postMessage;

  @override
  void initState() {
    super.initState();
    _postMessage = TextEditingController();
  }

  @override
  void dispose() {
    _postMessage.dispose();
    super.dispose();
  }

  bool _loading = false;
  String _email = "";

  @override
  Widget build(BuildContext context) {
    final emailInput = TextFormField(
      autocorrect: false,
      controller: _postMessage,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "No Message Found To Post";
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: "What do you want to post?",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          hintText: 'Enter Message'),
    );
  }
}
 */
