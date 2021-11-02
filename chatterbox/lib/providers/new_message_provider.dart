import 'package:chatterbox/Service/db.dart';
import 'package:chatterbox/models/user.dart';
import 'package:chatterbox/new_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessageProvider extends StatelessWidget {
  const NewMessageProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
      value: Database.streamUsers(),
      initialData: const [],
      child: const NewMessageScreen(),
    );
  }
}
