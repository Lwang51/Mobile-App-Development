import 'package:flutter/material.dart';
import 'package:midterm/LoginMethods/AnonymousLogin/landing_page.dart';
import 'package:midterm/LoginMethods/FacebookLogin/facebook.dart';
import 'package:midterm/LoginMethods/GoogleLogin/sign_in.dart';
import 'package:midterm/LoginMethods/PhoneNumberLogin/phone.dart';
import 'package:midterm/LoginMethods/email_login.dart';
import 'package:midterm/LoginMethods/email_password.dart';
import 'package:midterm/LoginMethods/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerButton = OutlinedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (con) => const RegisterPage()));
      },
      child: const Text('Register'),
    );

    final facebookButton = OutlinedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (con) => const FacebookLoginPage()));
      },
      child: const Text('Register'),
    );

    final googleButton = OutlinedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (con) => const GoogleSignInButton()));
      },
      child: const Text('Register'),
    );

    final emailPasswordButton = OutlinedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (con) => const EmailPassword()));
      },
      child: const Text('Register'),
    );

    final phoneNumberButton = OutlinedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (con) => const PhoneNumber()));
      },
      child: const Text('Register'),
    );

    final emailButton = OutlinedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (con) => const Email()));
      },
      child: const Text('Register'),
    );

    final anonymousButton = OutlinedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (con) => const Anonymous()));
      },
      child: const Text('Register'),
    );

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // Add TextFormFields and ElevatedButton here.
                        registerButton,
                        emailPasswordButton,
                        emailButton,
                        phoneNumberButton,
                        facebookButton,
                        googleButton,
                        anonymousButton
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
