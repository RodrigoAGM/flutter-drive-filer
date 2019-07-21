import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drive_filer/bloc/home_bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/domain/repository/google_sign_in_repository.dart';
import 'package:flutter_drive_filer/ui/home/home_events.dart';
import 'package:flutter_drive_filer/ui/home/home_states.dart';
import 'package:flutter_drive_filer/ui/res/color_tools.dart';
import 'package:flutter_drive_filer/ui/res/folder_colors.dart';
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
  var parent = "";
  var selectedItem;
  var selected = false;
  var folderSelectedColor = FolderColors.Rainy_sky;

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

  void updateSelected(value){
    selected = false;
    selectedItem = null;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    final textColor = Colors.black54;
    final selectedColor = Colors.blue[200];

    return BlocProvider<HomeBloc>(
      bloc: _homeBloc,
      child: Scaffold(

        appBar: (selected) ? MySelectedAppbar(textColor, _homeBloc, selectedColor, this).build(context) : MyAppbar(textColor, _homeBloc).build(this.context),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(parent != ""){
              var foldername = "";
              var folderdescription = "";
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: Text("Create Folder"),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("What's the name of the course?"),
                          Container(height: 20.0,),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value){
                              foldername = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Folder Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                              )
                            )
                          ),
                          Container(height: 10.0,),
                          TextField(
                            maxLines: 3,
                            onChanged: (value){
                              folderdescription = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                              )
                            )
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel", style: TextStyle(color: Colors.red)),
                      ),
                      FlatButton(
                        onPressed: (){
                          _homeBloc.dispatch(HomeEventCreateFolder(parent, foldername, folderdescription));
                          Navigator.pop(context);
                        },
                        child: Text("Create",),
                      ),
                    ],
                  );
                }
              );
            }
          },
          child: new Icon(Icons.create_new_folder),
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

                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.files.length,
                          itemBuilder: (context, index) {
                            return ListBody(
                              children: <Widget>[
                                InkWell(
                                  onLongPress: (){
                                    setState((){
                                      selectedItem = index;
                                      selected = true;
                                    });
                                  },
                                  onTap: (){},
                                  child: Container(
                                    alignment: Alignment.center,

                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).size.width/30,
                                      left: MediaQuery.of(context).size.width/15,
                                      right: MediaQuery.of(context).size.width/15,
                                      top: MediaQuery.of(context).size.width/30,
                                    ),

                                    height: (MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/2,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: Icon(
                                            Icons.folder,
                                            size: ((MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/3),
                                            color: HexColor(state.files[index].folderColorRgb),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  state.files[index].name,
                                                  style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold,),
                                              ),
                                              Center(
                                                child: Container(
                                                  alignment:Alignment.center,
                                                  margin: EdgeInsets.only(top: 10.0),
                                                  width: ((MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/2),
                                                  child: Text(
                                                    (state.files[index].description != null) ? state.files[index].description : 'No description.',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      shape: BoxShape.rectangle,
                                      color: (selectedItem != null && selectedItem == index)? selectedColor : Colors.grey[100],
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(1.0, 6.0)
                                        ),
                                      ]
                                    ),
                                  )
                                ),
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

class MyAppbar extends AppBar {
  final Color textColor;
  final HomeBloc _homeBloc;
  MyAppbar(this.textColor, this._homeBloc);

  Widget build(BuildContext context) {
    return AppBar(
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
        color: textColor,
        iconSize: 30.0,
        onPressed: (){

          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context){
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text("Confirmation"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Do you want to logout?"),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("No", style: TextStyle(color: Colors.red),),
                  ),
                  FlatButton(
                    onPressed: (){
                      _homeBloc.dispatch(HomeEventSignOut(context));
                      Navigator.pop(context);
                    },
                    child: Text("Yes"),
                  ),
                ],
              );
            }
          );
        },
        highlightColor: Colors.white30,
        splashColor: Colors.white30,
      ),
    );
  }
}

class MySelectedAppbar extends AppBar {
  final Color textColor;
  final HomeBloc _homeBloc;
  final Color selectedColor;
  var selected;
  MySelectedAppbar(this.textColor, this._homeBloc, this.selectedColor, this.selected);

  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: selectedColor,
      elevation: 0.0,
      titleSpacing: 0.0,
      title: Text(Strings.app_name, style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.color_lens),
          color: textColor,
          iconSize: 30.0,
          onPressed: (){},
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
        new IconButton(
          icon: new Icon(Icons.delete),
          color: textColor,
          iconSize: 30.0,
          onPressed: (){},
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
      ],
      leading: IconButton(
        icon: new Icon(Icons.cancel),
        color: textColor,
        iconSize: 30.0,
        onPressed: (){
          selected.updateSelected(false);
        },
        highlightColor: Colors.white30,
        splashColor: Colors.white30,
      ),
    );
  }
}