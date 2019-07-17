import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/bloc/sign_in_bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_sign_in_repository.dart';
import 'package:flutter_drive_filer/ui/home/home.dart';
import 'package:flutter_drive_filer/ui/login/login_events.dart';
import 'package:flutter_drive_filer/ui/login/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatefulWidget {
  @override
  State createState() => _SignInState();
}

class _SignInState extends State<SignIn>{

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(googleSignInRepository: GoogleSignInRepository());
    _loginBloc.dispatch(LoginEventInitSignIn());
  }

  @override
  void dispose(){
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<LoginBloc>(
      bloc: _loginBloc,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: BlocBuilder<LoginEvent,LoginState>(
                bloc: _loginBloc,
                builder: (BuildContext context, LoginState state){

                  if(state is LoginStateDefault){
                    return Center(
                      child: RaisedButton(
                        child: const Text('SIGN IN'),
                        onPressed: (){
                          _loginBloc.dispatch(LoginEventSignIn());
                        },
                      ),
                    );
                  }

                  if(state is LoginStateLoading){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(state is LoginStateError){
                    return Center(
                      child: Text(
                        'Connection error!',
                        style: TextStyle(color: Colors.red, fontSize: 24.0),
                      ),
                    );
                  }

                  if(state is LoginStateLoggedIn){
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Connected ' + state.currentUser.displayName + ' !',
                            style: TextStyle(color: Colors.blue, fontSize: 24.0),
                          ),
                          RaisedButton(
                            child: const Text('SIGN OUT'),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Home(state.currentUser)));
                            },
                          ),
                        ],
                      )
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}