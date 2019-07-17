import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drive_filer/bloc/home_bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/home/home_events.dart';
import 'package:flutter_drive_filer/ui/home/home_states.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget{

  final GoogleSignInAccount _account;

  Home(this._account);

  @override
  State createState() => _HomeState(_account);

}

class _HomeState extends State<Home>{

  HomeBloc _homeBloc;
  GoogleSignInAccount _account;

  _HomeState(this._account);

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(googleDriveRepository: GoogleDriveRepository(_account));
    _homeBloc.dispatch(HomeEventListFolders());
  }

  @override
  void dispose(){
    super.dispose();
    _homeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      bloc: _homeBloc,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: BlocBuilder<HomeEvent,HomeState>(
                bloc: _homeBloc,
                builder: (BuildContext context, HomeState state){
                  if(state is HomeStateDefault){
                    return Center(
                      child: RaisedButton(
                        child: const Text('Refresh'),
                        onPressed: (){
                          _homeBloc.dispatch(HomeEventListFolders());
                        },
                      ),
                    );
                  }

                  if(state is HomeStateLoading){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(state is HomeStateError){
                    return Center(
                      child: Text(
                        'Connection error!',
                        style: TextStyle(color: Colors.red, fontSize: 24.0),
                      ),
                    );
                  }

                  if(state is HomeStateSearched){
                    return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              (state.files.length == 0)? 'No folders found !' : state.files.length.toString() + ' folders found!',
                              style: TextStyle(color: Colors.blue, fontSize: 24.0),
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