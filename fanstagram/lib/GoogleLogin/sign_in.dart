//Code from https://medium.com/flutter-community/flutter-implementing-google-sign-in-71888bca24ed
//Code from https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/

import 'package:fanstagram/UI/error.dart';
import 'package:fanstagram/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                FirebaseAuth auth = FirebaseAuth.instance;

                User? user;

                final GoogleSignIn googleSignIn = GoogleSignIn();

                final GoogleSignInAccount? googleSignInAccount =
                    await googleSignIn.signIn();

                if (googleSignInAccount != null) {
                  final GoogleSignInAuthentication googleSignInAuthentication =
                      await googleSignInAccount.authentication;

                  final AuthCredential credential =
                      GoogleAuthProvider.credential(
                    accessToken: googleSignInAuthentication.accessToken,
                    idToken: googleSignInAuthentication.idToken,
                  );

                  try {
                    final UserCredential userCredential =
                        await auth.signInWithCredential(credential);

                    user = userCredential.user;
                    if (user != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => AppDriver()));
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ErrorPage()));
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'account-exists-with-different-credential') {
                      // handle the error here
                    } else if (e.code == 'invalid-credential') {
                      // handle the error here
                    }
                  } catch (e) {
                    // handle the error here
                  }
                }
                setState(() {
                  _isSigningIn = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Image(
                      image: AssetImage("assets/google.png"),
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
