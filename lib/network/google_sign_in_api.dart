import 'package:flutter_drive_filer/domain/repository/google_sign_in_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi{
  final googleSignInRepository = GoogleSignInRepository();

  Future<GoogleSignInAccount> initUser(){
    return googleSignInRepository.initUser();
  }

  Future<void> handleSignIn(){
    return googleSignInRepository.handleSignIn();
  }

  Future<void> handleSignOut(){
    return googleSignInRepository.handleSignOut();
  }

}