//code from: https://firebase.flutter.dev/docs/firestore/usage/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanstagram/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  CustomerView createState() => CustomerView();
}

class CustomerView extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('Messages')
      .orderBy('postDateTime', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _messageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
      ),
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
