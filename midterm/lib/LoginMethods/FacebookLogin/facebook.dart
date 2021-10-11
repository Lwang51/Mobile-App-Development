//code from: https://github.com/myvsparth/flutter_fb_login/blob/master/lib/pages/login_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter/material.dart';
import 'package:midterm/Control/driver.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({Key? key}) : super(key: key);

  @override
  FacebookLoginState createState() => FacebookLoginState();
}

class FacebookLoginState extends State<FacebookLoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FacebookLogin fbLogin = FacebookLogin();
  bool isFacebookLoginIn = false;
  String errorMessage = '';
  String successMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Email Login'),
      ),
      body: Center(
          child: Column(
        children: [
          (!isFacebookLoginIn
              ? ElevatedButton(
                  child: const Text('Facebook Login'),
                  onPressed: () {
                    facebookLogin(context).then((user) {
                      // ignore: unnecessary_null_comparison
                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Logged in successfully.")));
                        setState(() {
                          isFacebookLoginIn = true;
                          successMessage =
                              'Logged in successfully.\nEmail : ${user.email}';
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => AppDriver()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login Error.")));
                      }
                    });
                  },
                )
              : ElevatedButton(
                  child: const Text('Facebook Logout'),
                  onPressed: () {
                    facebookLoginout().then((response) {
                      if (response) {
                        setState(() {
                          isFacebookLoginIn = false;
                          successMessage = '';
                        });
                      }
                    });
                  },
                )),
        ],
      )),
    );
  }

  Future<User> facebookLogin(BuildContext context) async {
    User currentUser = auth.currentUser!;
    // fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // if you remove above comment then facebook login will take username and pasword for login in Webview
    try {
      final FacebookLoginResult facebookLoginResult = await fbLogin.logIn();
      if (facebookLoginResult.status == FacebookLoginStatus.success) {
        FacebookAccessToken? facebookAccessToken =
            facebookLoginResult.accessToken;
        AuthCredential credential =
            FacebookAuthProvider.credential(facebookAccessToken!.token);
        final User user = (await auth.signInWithCredential(credential)) as User;
        assert(user.email != null);
        assert(user.displayName != null);
        assert(!user.isAnonymous);
        // ignore: unnecessary_null_comparison
        assert(await user.getIdToken() != null);
        currentUser = auth.currentUser!;
        assert(user.uid == currentUser.uid);
        return currentUser;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return currentUser;
  }

  Future<bool> facebookLoginout() async {
    await auth.signOut();
    await fbLogin.logOut();
    return true;
  }
}
