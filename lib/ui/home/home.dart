import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drive_filer/bloc/home_bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/home/home_events.dart';
import 'package:flutter_drive_filer/ui/home/home_states.dart';
import 'package:flutter_drive_filer/ui/res/strings.dart';
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
    final textColor = Colors.black54;
    return BlocProvider<HomeBloc>(
      bloc: _homeBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          titleSpacing: 0.0,
          title: Text(Strings.app_name, style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.camera_alt),
              color: textColor,
              iconSize: 30.0,
              onPressed: (){},
              highlightColor: Colors.white30,
              splashColor: Colors.white30,
            ),
          ],
          leading: IconButton(
            icon: new Icon(Icons.exit_to_app),
            // icon: new ClipOval(
            //   child: Image.network(_account.photoUrl)
            // ),
            color: textColor,
            iconSize: 30.0,
            onPressed: (){},
            highlightColor: Colors.white30,
            splashColor: Colors.white30,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){},
          icon: new Icon(Icons.create_new_folder),
          label: Text('Add folder'),
        ),
        body: Stack(
          children: <Widget>[
            //Searcher
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                },
                controller: null,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Center(
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