import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable{}

class LoginEventSignIn extends LoginEvent {

  @override
  String toString() => 'LoginEventSignIn';
}

class LoginEventInitSignIn extends LoginEvent {

  @override
  String toString() => 'LoginEventInitSignIn';
}

class LoginEventSignOut extends LoginEvent {

  @override
  String toString() => 'LoginEventSignOut';
}
