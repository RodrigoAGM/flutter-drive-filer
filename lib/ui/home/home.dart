import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drive_filer/bloc/home_bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/domain/repository/google_sign_in_repository.dart';
import 'package:flutter_drive_filer/ui/home/home_events.dart';
import 'package:flutter_drive_filer/ui/home/home_states.dart';
import 'package:flutter_drive_filer/ui/res/strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart';

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
    _homeBloc = HomeBloc(googleDriveRepository: GoogleDriveRepository(_account), googleSignInRepository: GoogleSignInRepository());
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
    var parent = "";
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
            onPressed: (){

              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Confirmation"),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("Do you want to logout?")
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: (){
                          _homeBloc.dispatch(HomeEventSignOut(context));
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                    ],
                  );
                }
              );
            },
            highlightColor: Colors.white30,
            splashColor: Colors.white30,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(parent != ""){
              var foldername = "Not working";
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Confirmation"),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("What's the name of the course?"),
                          TextField(
                            onChanged: (value){
                              foldername = value;
                            },
                            decoration: InputDecoration(
                              labelText: "Folder Name",
                              hintText: "Folder Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                              )
                            )
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: (){
                          _homeBloc.dispatch(HomeEventCreateFolder(parent, foldername));
                          Navigator.pop(context);
                        },
                        child: Text("Create"),
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  );
                }
              );
            }
          },
          icon: new Icon(Icons.create_new_folder),
          label: Text('Add folder'),
        ),


        body: Column(

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
            Expanded(
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
                    parent = state.parent;
                    if(state.files.length == 0){
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'No folders found !',
                              style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      );
                    }else{
                      return Container(
                        // child: Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: <Widget>[
                        //     Text(
                        //       (state.files.length == 0)? 'No folders found !' : state.files.length.toString() + ' folders found!',
                        //       style: TextStyle(color: Colors.blue, fontSize: 24.0),
                        //     ),
                        //   ],
                        // )
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.files.length,
                          itemBuilder: (context, index) {
                            return ListBody(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,

                                  margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.width/15,
                                    left: MediaQuery.of(context).size.width/15,
                                    right: MediaQuery.of(context).size.width/15),

                                  height: (MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/2,
                                  child: Text(state.files[index].name),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    shape: BoxShape.rectangle,
                                    color: Colors.grey[100],
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        offset: Offset(1.0, 6.0)
                                      ),
                                    ]
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      );
                    }
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
