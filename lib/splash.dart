import 'package:emandi/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => loginPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.jpg'),
              maxRadius: 100,
            ),
          ),
          Text(
            'Welcome to eMandi',
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 28),
          )
        ],
      ),
    ));
  }
}
