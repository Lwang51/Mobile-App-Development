import 'package:chatterbox/providers/convo_provider.dart';
import 'package:chatterbox/Service/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDriver extends StatefulWidget {
  const AppDriver({Key? key}) : super(key: key);

  @override
  Driver createState() => Driver();
}

class Driver extends State<AppDriver> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    // ignore: unnecessary_null_comparison
    return (user != null)
        ? ConversationProvider(user: user)
        : const LoginPage();
  }
}
