import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/ui/login/sign_in.dart';
import 'package:flutter_drive_filer/ui/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlocMainDelegate extends BlocDelegate{

  @override
  void onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
  }
}

void main(){
  BlocSupervisor().delegate = BlocMainDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: new Splash(),
    );
  }
}


class Splash extends StatefulWidget {

  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future checkOnBoarding() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _show = (prefs.getBool('show') ?? true);

    if (_show) {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new OnboardingMainPage()));
    } else {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new SignIn()));
    }

  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
      checkOnBoarding();
    });
  }

  @override
  Widget build(BuildContext context) {
      return new Scaffold(
      body: new Center(
          child: new CircularProgressIndicator(),
      ),
      );
  }

}