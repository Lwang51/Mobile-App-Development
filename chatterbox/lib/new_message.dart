import 'package:chatterbox/models/user.dart';
import 'package:chatterbox/user_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final List<Users> userDirectory = Provider.of<List<Users>>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Select Contact')),
      // ignore: unnecessary_null_comparison
      body: user != null && userDirectory != null
          ? ListView(
              shrinkWrap: true, children: getListViewItems(userDirectory, user))
          : Container(),
    );
  }

  List<Widget> getListViewItems(List<Users> userDirectory, User user) {
    final List<Widget> list = <Widget>[];
    for (Users contact in userDirectory) {
      if (contact.id != user.uid) {
        list.add(UserRow(uid: user.uid, contact: contact));
        list.add(const Divider(thickness: 1.0));
      }
    }
    return list;
  }
}
