import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive',
  ]
);

class Sign_in extends StatefulWidget {

  @override
  State createState() => SignInState();
}

class SignInState extends State<Sign_in>{
  GoogleSignInAccount _currentUser;

  void initState(){
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account){
      setState((){
        _currentUser = account;
      });
      if (_currentUser != null){
        //TODO
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn()async{
    try{
      await _googleSignIn.signIn();
    }catch(error){
      print(error);
    }
  }

  Future<void> _handleSignOut()async{
    _googleSignIn.disconnect();
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // ignore: const_eval_throws_exception, const_eval_throws_exception, invalid_constant
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign in'),
      ),
      body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
      ),
    );
  }

}