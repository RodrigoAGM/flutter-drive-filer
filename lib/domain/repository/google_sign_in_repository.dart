import 'dart:async';
import 'dart:core';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInRepository{

  GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/drive',
      ]
  );

  Future<GoogleSignInAccount> initUser() async{
    GoogleSignInAccount _currentUser;
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account){
      _currentUser = account;
    });
    await _googleSignIn.signInSilently();
    return _currentUser;
  }

  Future<GoogleSignInAccount> handleSignIn()async{
    try{
      await _googleSignIn.signIn();
      return _googleSignIn.currentUser;
    }catch(error){
      print(error);
    }
    return null;
  }

  Future<void> handleSignOut()async{
    _googleSignIn.disconnect();
  }

}