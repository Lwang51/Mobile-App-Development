import 'dart:async';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatterbox/models/convo.dart';
import 'package:chatterbox/models/user.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(User user) async {
    await _db.collection('users').doc(user.uid).set({
      'id': user.uid,
      'name': user.displayName,
      'email': user.email,
      "userRating": 0,
      "totalRating": 0,
    });
  }

  static Stream<List<Users>>? streamUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot snap) =>
                Users.fromMap(snap.data as Map<String, dynamic>))
            .toList())
        .handleError((dynamic e) {
      ScaffoldMessenger.of(e)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    });
  }

  static Stream<List<Users>> getUsersByList(List<String> userIds) {
    final List<Stream<Users>> streams = [];
    for (String id in userIds) {
      streams.add(_db.collection('users').doc(id).snapshots().map(
          (DocumentSnapshot snap) =>
              Users.fromMap(snap.data as Map<String, dynamic>)));
    }
    return StreamZip<Users>(streams).asBroadcastStream();
  }

  static Stream<List<Convo>> streamConversations(String uid) {
    return _db
        .collection('messages')
        .orderBy('lastMessage.timestamp', descending: true)
        .where('users', arrayContains: uid)
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot doc) => Convo.fromFireStore(doc))
            .toList());
  }

  static void sendMessage(
    String convoID,
    String id,
    String pid,
    String content,
    String timestamp,
  ) {
    final DocumentReference convoDoc =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    convoDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': id,
        'idTo': pid,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': <String>[id, pid]
    }).then((dynamic success) {
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('messages')
          .doc(convoID)
          .collection(convoID)
          .doc(timestamp);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        transaction.set(
          messageDoc,
          <String, dynamic>{
            'idFrom': id,
            'idTo': pid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        );
      });
    });
  }

  static void updateMessageRead(DocumentSnapshot doc, String convoID) {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(convoID)
        .doc(doc.id);

    documentReference.set(<String, dynamic>{'read': true});
  }

  static void updateLastMessage(
      DocumentSnapshot doc, String uid, String pid, String convoID) {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    documentReference
        .set(<String, dynamic>{
          'lastMessage': <String, dynamic>{
            'idFrom': doc['idFrom'],
            'idTo': doc['idTo'],
            'timestamp': doc['timestamp'],
            'content': doc['content'],
            'read': doc['read']
          },
          'users': <String>[uid, pid]
        })
        .then((dynamic success) {})
        .catchError((dynamic error) {
          ScaffoldMessenger.of(error)
              .showSnackBar(SnackBar(content: Text(error.code.toString())));
        });
  }

  /*static int getStars(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get("userRating");
  }*/
}
