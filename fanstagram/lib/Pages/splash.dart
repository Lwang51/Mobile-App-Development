import 'dart:async';
import 'package:fanstagram/after_splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<Splash> createState() => _Splash();
}

class _Splash extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 15),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const AfterSplash())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.lightBlue,
                Colors.pink.shade100,
              ],
            )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: (700),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/splash.jpg"),
                            fit: BoxFit.fill),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    const Text(
                      "Your Star: Landon Wang",
                      style: TextStyle(
                          color: Color.fromARGB(255, 212, 175, 55),
                          fontWeight: FontWeight.bold,
                          fontSize: 45.0),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "FANSTAGRAM",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

/* 
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 10,
        navigateAfterSeconds: const AfterSplash(),
        title: const Text(
          'Fanstagram',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset("assets/splash.jpg"),
        backgroundColor: Colors.lightBlue,
        photoSize: 500.0,
        loaderColor: Colors.blue);
  }
*/
