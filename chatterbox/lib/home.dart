import 'package:chatterbox/models/user.dart';
import 'package:chatterbox/providers/new_message_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatterbox/convo_widget.dart';
import 'package:chatterbox/driver.dart';
import 'package:chatterbox/models/convo.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final List<Convo> _convos = Provider.of<List<Convo>>(context);
    final List<Users> _users = Provider.of<List<Users>>(context);
    return Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                onPressed: () => _signOut,
                icon: const Icon(Icons.logout, size: 30)),
            Text(user.displayName.toString(),
                style: const TextStyle(fontSize: 18)),
            IconButton(
                onPressed: () => createNewConvo(context),
                icon: const Icon(Icons.add, size: 30))
          ],
        )),
        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: getWidgets(context, user, _convos, _users)));
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (con) => const AppDriver()));
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

  void createNewConvo(BuildContext context) {
    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const NewMessageProvider()));
  }

  Map<String, Users> getUserMap(List<Users> users) {
    final Map<String, Users> userMap = {};
    for (Users u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }

  List<Widget> getWidgets(BuildContext context, User user, List<Convo> _convos,
      List<Users> _users) {
    final List<Widget> list = <Widget>[];
    // ignore: unnecessary_null_comparison
    if (_convos != null && _users != null && user != null) {
      final Map<String, Users> userMap = getUserMap(_users);
      for (Convo c in _convos) {
        if (c.userIds[0] == user.uid) {
          list.add(ConvoListItem(
            user: user,
            peer: userMap[c.userIds[1]],
            lastMessage: c.lastMessage,
            key: null,
          ));
        } else {
          list.add(ConvoListItem(
            user: user,
            peer: userMap[c.userIds[0]],
            lastMessage: c.lastMessage,
            key: null,
          ));
        }
      }
    }

    return list;
  }
}
