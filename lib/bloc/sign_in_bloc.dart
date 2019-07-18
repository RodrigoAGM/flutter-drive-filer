import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/domain/repository/google_sign_in_repository.dart';
import 'package:flutter_drive_filer/ui/home/home.dart';
import 'package:flutter_drive_filer/ui/login/login_events.dart';
import 'package:flutter_drive_filer/ui/login/login_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{

  final GoogleSignInRepository googleSignInRepository;

  LoginBloc({this.googleSignInRepository});

  @override
  LoginState get initialState => LoginStateDefault();

  @override
  Stream<LoginState> mapEventToState(LoginState state,LoginEvent event) async* {
    if(event is LoginEventInitSignIn){
      yield* _mapSignInInitState(event);
    }

    if(event is LoginEventSignIn){
      yield* _mapSignInState(event);
    }

    if(event is LoginEventSignOut){
      yield* _mapSignOutState(event);
    }
  }

  Stream<LoginState> _mapSignInInitState(LoginEventInitSignIn event) async*{
    try{
      yield LoginStateLoading();
      var result = await googleSignInRepository.initUser();
      if(result == null) {
        yield LoginStateDefault();
      }else{
        Navigator.pushReplacement(event.context, MaterialPageRoute(builder: (context) => Home(result)));
        //yield LoginStateLoggedIn(currentUser: result);
      }
    }catch(e){
      yield LoginStateError();
    }
  }

  Stream<LoginState> _mapSignInState(LoginEventSignIn event) async*{
    try{
      var result = await googleSignInRepository.handleSignIn();
      if(result == null) {
        yield LoginStateError();
      }else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('show', false);
        Navigator.pushReplacement(event.context, MaterialPageRoute(builder: (context) => Home(result)));
        //yield LoginStateLoggedIn(currentUser: result);
      }
    }catch(e){
      yield LoginStateError();
    }
  }

  Stream<LoginState> _mapSignOutState(LoginEventSignOut event) async*{
    try{
      yield LoginStateLoading();
      await googleSignInRepository.handleSignOut();
      yield LoginStateDefault();
    }catch(e){
      yield LoginStateError();
    }
  }



}