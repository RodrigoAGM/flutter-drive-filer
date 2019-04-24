import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState extends Equatable{
  LoginState([List props = const []]) : super(props);
}

class LoginStateDefault extends LoginState {
  @override
  String toString() => 'LoginStateDefault';
}

class LoginStateLoading extends LoginState {
  @override
  String toString() => 'LoginStateLoading';
}

class LoginStateError extends LoginState {
  @override
  String toString() => 'LoginStateError';
}

class LoginStateLoggedIn extends LoginState {

  final GoogleSignInAccount currentUser;

  LoginStateLoggedIn({this.currentUser});

  @override
  String toString() => 'LoginStateLoggedIn';
}