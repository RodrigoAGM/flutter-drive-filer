import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable{}

class LoginEventSignIn extends LoginEvent {

  final BuildContext context;

  LoginEventSignIn(this.context);

  @override
  String toString() => 'LoginEventSignIn';
}

class LoginEventInitSignIn extends LoginEvent {

  final BuildContext context;

  LoginEventInitSignIn(this.context);

  @override
  String toString() => 'LoginEventInitSignIn';
}

class LoginEventSignOut extends LoginEvent {

  @override
  String toString() => 'LoginEventSignOut';
}
