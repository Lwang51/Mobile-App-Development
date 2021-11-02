import 'package:chatterbox/Service/db.dart';
import 'package:chatterbox/home.dart';
import 'package:chatterbox/models/convo.dart';
import 'package:chatterbox/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationProvider extends StatelessWidget {
  const ConversationProvider({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Convo>>.value(
        value: Database.streamConversations(user.uid),
        initialData: const [],
        child: ConversationDetailsProvider(user: user));
  }
}

class ConversationDetailsProvider extends StatelessWidget {
  const ConversationDetailsProvider({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
        value: Database.getUsersByList(
            getUserIds(Provider.of<List<Convo>>(context))),
        initialData: const [],
        child: HomePage());
  }

  List<String> getUserIds(List<Convo> _convos) {
    final List<String> users = <String>[];
    // ignore: unnecessary_null_comparison
    if (_convos != null) {
      for (Convo c in _convos) {
        c.userIds[0] != user.uid
            ? users.add(c.userIds[0])
            : users.add(c.userIds[1]);
      }
    }
    return users;
  }
}
