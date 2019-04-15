import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/ui/login/sign_in.dart';
import 'package:flutter_drive_filer/ui/onboarding/onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      routes: <String, WidgetBuilder> {
        '/onboarding': (BuildContext context) => new OnboardingMainPage(),
        '/login': (BuildContext context) => new Sign_in(),
      },
      home: new OnboardingMainPage(),
    );
  }
}



