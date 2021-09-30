import 'package:fanstagram/GoogleLogin/authentication.dart';
import 'package:fanstagram/GoogleLogin/sign_in.dart';
import 'package:fanstagram/Pages/register.dart';
import 'package:fanstagram/UI/loading.dart';
import 'package:fanstagram/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController, _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _loading = false;
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    final emailInput = TextFormField(
      autocorrect: false,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "---please enter an email---";
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: "EMAIL ADDRESS",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          hintText: 'Enter Email'),
    );
    final passwordInput = TextFormField(
      autocorrect: false,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "---please enter a password---";
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "PASSWORD",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        hintText: 'Enter Password',
        suffixIcon: Padding(
          padding: EdgeInsets.all(15), // add padding to adjust icon
          child: Icon(Icons.lock),
        ),
      ),
    );
    final submitButton = OutlinedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Processing Data")));
          _email = _emailController.text;
          _password = _passwordController.text;

          _emailController.clear();
          _passwordController.clear();

          setState(() {
            _loading = true;
            login();
          });
        }
      },
      child: const Text('Submit'),
    );

    final registerButton = OutlinedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (con) => const RegisterPage()));
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
                    _auth.currentUser != null
                        ? Text(_auth.currentUser!.uid)
                        : _loading
                            ? const LoadingPage()
                            : Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    // Add TextFormFields and ElevatedButton here.
                                    emailInput,
                                    passwordInput,
                                    submitButton,
                                    registerButton
                                  ],
                                ),
                              )
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return const GoogleSignInButton();
                  }
                  return Container(
                      child: const Center(child: CircularProgressIndicator()),
                      color: Colors.white);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      UserCredential _ = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (con) => AppDriver()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.code.toString())));
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }

    setState(() {
      _loading = false;
    });
  }

  /* https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
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

    return user;
  } */
}
