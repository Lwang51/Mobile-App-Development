//Code From: https://medium.com/@ayushsahu_52982/passwordless-login-with-firebase-flutter-f0819209677
//Code From: https://itnext.io/flutter-passwordless-login-with-firebase-8cb085c4fb67

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Email> with WidgetsBindingObserver {
  String _email = "";
  String _link = "";
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth user = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) return "Email cannot be empty";
        return null;
      },
      onSaved: (value) => _email = value!,
      decoration: InputDecoration(
        hintText: 'Email',
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: const Text("Send Verification Email"),
        onPressed: (() async => await validateAndSave()
            ? ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Email Sent!")))
            : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Email Not Sent. Error.")))),
        padding: const EdgeInsets.all(12),
      ),
    );

    final loginForm = Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 24, right: 24),
        children: <Widget>[
          const SizedBox(height: 50),
          email,
          const SizedBox(height: 40),
          loginButton
        ],
      ),
    );
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(child: loginForm));
  }

  Future<bool> validateAndSave() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      bool sent = await _sendSignInWithEmailLink();
      return sent;
    }
    return false;
  }

  Future<bool> _sendSignInWithEmailLink() async {
    try {
      user.sendSignInLinkToEmail(
          email: _email,
          actionCodeSettings: ActionCodeSettings(
              url: "https://midtermpasswordless.page.link/eNh4",
              androidPackageName: "com.MAD.midterm",
              handleCodeInApp: true,
              androidMinimumVersion: "16",
              androidInstallApp: true));
    } catch (e) {
      _showDialog(e.toString());
      return false;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(_email + "<< sent")));
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _retrieveDynamicLink();
    }
  }

  Future<String> _retrieveDynamicLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getDynamicLink(Uri());

    final Uri? deepLink = data!.link;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(deepLink.toString())));

    _link = deepLink.toString();
    _signInWithEmailAndLink();
    return deepLink.toString();
  }

  Future<void> _signInWithEmailAndLink() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    bool validLink = user.isSignInWithEmailLink(_link);
    if (validLink) {
      try {
        await user.signInWithEmailLink(email: _email, emailLink: _link);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        _showDialog(e.toString());
      }
    }
  }

  void _showDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text("Please Try Again.Error code: " + error),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
