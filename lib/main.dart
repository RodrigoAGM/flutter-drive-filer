import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/ui/onboarding/onboarding.dart';

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
      home: new OnboardingMainPage(),
    );
  }
}



