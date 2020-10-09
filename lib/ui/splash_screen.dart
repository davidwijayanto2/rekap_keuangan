import 'dart:async';
import 'package:rekap_keuangan/ui/initdompet_screen.dart';
import 'package:flutter/services.dart';
import 'package:rekap_keuangan/ui/intro_screen.dart';
import 'package:rekap_keuangan/ui/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: SplashScreen()));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return IntroScreen();
      }));
    });
  }

  @override
  void initState() {
    super.initState();
    //startTime();
  }

  @override
  Widget build(BuildContext context) {
    //startTime();
    return Container(
        child: Center(
      child: Text('SPLASH SCREEN'),
    ));
  }
}
