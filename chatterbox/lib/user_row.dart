import 'package:chatterbox/Tools/help.dart';
import 'package:chatterbox/models/user.dart';
import 'package:chatterbox/new_convo.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserRow extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const UserRow({required this.uid, required this.contact});
  final String uid;
  final Users contact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => createConversation(context),
      //onDoubleTap: () => starRater(context),
      child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Text(contact.name,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)))),
    );
  }

  void createConversation(BuildContext context) {
    String convoID = HelperFunctions.getConvoID(uid, contact.id);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => NewConversationScreen(
            uid: uid, contact: contact, convoID: convoID)));
  }

  /*
  starRater(BuildContext context) {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    _db.collection("users").doc(uid).get("userRating", "totalRating");

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // ignore: avoid_print
        print(doc["first_name"]);
      }
    });
  }*/
}
