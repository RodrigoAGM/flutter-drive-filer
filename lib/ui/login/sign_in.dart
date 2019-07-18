import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/bloc/sign_in_bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_sign_in_repository.dart';
import 'package:flutter_drive_filer/ui/home/home.dart';
import 'package:flutter_drive_filer/ui/login/login_events.dart';
import 'package:flutter_drive_filer/ui/login/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drive_filer/ui/res/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    final textColor = Colors.black45;

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new SizedBox(
                              child: Image(
                                image: AssetImage('assets/googledrive.png'),
                                fit: BoxFit.fitHeight,
                              ),
                              height: MediaQuery.of(context).size.width/2,
                              width: MediaQuery.of(context).size.width/2,
                          ),
                          new Container(
                            child: Text(
                              Strings.app_name,
                              style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          new SizedBox(height: 10.0,),
                          new RaisedButton(
                            child: Text(
                              Strings.login_button,
                              style: Theme.of(context).textTheme.button.copyWith(color: textColor),),
                            onPressed: (){
                               _loginBloc.dispatch(LoginEventSignIn());
                            },
                            elevation: 7.0,
                            highlightColor: Colors.white30,
                            splashColor: Colors.white30,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          ),
                        ],
                      )
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
                        style: Theme.of(context).textTheme.button.copyWith(color: Colors.red),
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