import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drive_filer/bloc/pictures_list_bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/pictures_list/pictures_list_events.dart';
import 'package:flutter_drive_filer/ui/pictures_list/pictures_list_states.dart';
import 'package:flutter_drive_filer/ui/res/folder_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class PicturesList extends StatefulWidget {

  final GoogleSignInAccount _account;
  final File folder;

  PicturesList(this._account, this.folder);

  _PicturesListState createState() => _PicturesListState(folder, _account);
}

class _PicturesListState extends State<PicturesList> {

  PicturesListBloc _picturesListBloc;
  GoogleSignInAccount _account;
  File _folder;

  _PicturesListState(this._folder, this._account);

  var selectedItem;
  var selected = false;
  var folderSelectedColor = FolderColors.Rainy_sky;
  var allItemsList;

  @override
  void initState() {
    super.initState();
    _picturesListBloc = PicturesListBloc(GoogleDriveRepository(_account));
    _picturesListBloc.dispatch(PicturesListEventListPictures(_folder.id));
  }

  @override
  void dispose(){
    super.dispose();
    _picturesListBloc.dispose();
  }

  void updateSelected(value){
    selected = false;
    selectedItem = null;
    setState(() {
    });
  }

  Future<bool> _onWillPop() async{
    if(selected){
      selected = false;
      selectedItem = null;
      setState(() { });
      return false;
    }else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {

    final textColor = Colors.black54;
    final selectedColor = Colors.blue[200];

    return BlocProvider<PicturesListBloc>(
      bloc: _picturesListBloc,
      child: WillPopScope(

        onWillPop: _onWillPop,

        child: Scaffold(

          appBar: (selected) ? MySelectedAppbar(textColor, _picturesListBloc, selectedColor, this, selectedItem).build(context) : MyAppbar(textColor, _picturesListBloc, this).build(this.context),

          body: Column(

            children: <Widget>[

              Expanded(
                child: BlocBuilder<PicturesListEvent,PicturesListState>(
                  bloc: _picturesListBloc,
                  builder: (BuildContext context, PicturesListState state){

                    if(state is PicturesListStateDefault){
                      return Center(
                        child: RaisedButton(
                          child: const Text('Refresh'),
                          onPressed: (){
                            _picturesListBloc.dispatch(PicturesListEventListPictures(_folder.id));
                          },
                        ),
                      );
                    }

                    if(state is PicturesListStateLoading){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if(state is PicturesListStateError){
                      return Center(
                        child: Text(
                          'Connection error!',
                          style: TextStyle(color: Colors.red, fontSize: 24.0),
                        ),
                      );
                    }

                    if(state is PicturesListStateSearched){

                      allItemsList = state.files;

                      if(allItemsList.length == 0){
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No pictures found !',
                                style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        );
                      }else{
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                shrinkWrap: true,
                                itemCount: allItemsList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onLongPress: (){
                                      setState((){
                                        selectedItem = allItemsList[index];
                                        selected = true;
                                      });
                                    },
                                    onTap: (){

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.width/60,
                                        left: MediaQuery.of(context).size.width/30,
                                        right: MediaQuery.of(context).size.width/30,
                                        top: MediaQuery.of(context).size.width/60,
                                      ),

                                      height: (MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Image(
                                              image: NetworkImage(allItemsList[index].thumbnailLink),
                                              height: ((MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/3),
                                              width: ((MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/3),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                allItemsList[index].name,
                                                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold,),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                              ),
                                            )
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                        shape: BoxShape.rectangle,
                                        color: (selectedItem != null && selectedItem == allItemsList[index])? selectedColor : Colors.grey[100],
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5.0,
                                            offset: Offset(1.0, 6.0)
                                          ),
                                        ]
                                      ),
                                    )
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

class MyAppbar extends AppBar {
  final Color textColor;
  final PicturesListBloc _picturesListBloc;
  final _PicturesListState picturesList;

  MyAppbar(this.textColor, this._picturesListBloc, this.picturesList);

  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      titleSpacing: 0.0,
      title: Text(
        picturesList._folder.name,
        style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
        ),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.refresh),
          color: textColor,
          iconSize: 30.0,
          onPressed: (){
            _picturesListBloc.dispatch(PicturesListEventListPictures(picturesList._folder.id));
          },
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
        // new IconButton(
        //   icon: new Icon(Icons.camera_alt),
        //   color: textColor,
        //   iconSize: 30.0,
        //   onPressed: (){
        //     _courseDaysBloc.dispatch(CourseDaysEventTakePicture(courseDays.allItemsList, courseDays._course.id, context));
        //   },
        //   highlightColor: Colors.white30,
        //   splashColor: Colors.white30,
        // ),
      ],
      leading: IconButton(
        icon: new Icon(Icons.arrow_back),
        color: textColor,
        iconSize: 30.0,
        onPressed: (){
          Navigator.pop(context);
        },
        highlightColor: Colors.white30,
        splashColor: Colors.white30,
      ),
    );
  }
}

class MySelectedAppbar extends AppBar {
  final Color textColor;
  final PicturesListBloc _picturesListBloc;
  final Color selectedColor;
  final File selectedItem;
  final _PicturesListState picturesList;
  MySelectedAppbar(this.textColor, this._picturesListBloc, this.selectedColor, this.picturesList, this.selectedItem);

  Widget build(BuildContext context) {

    return AppBar(
      centerTitle: true,
      backgroundColor: selectedColor,
      elevation: 0.0,
      titleSpacing: 0.0,
      title: Text(selectedItem.name, style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.share),
          color: textColor,
          iconSize: 30.0,
          onPressed: (){

            picturesList.updateSelected(false);
          },
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
        new IconButton(
          icon: new Icon(Icons.delete),
          color: textColor,
          iconSize: 30.0,
          onPressed: (){
            return showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Do you want to delete " + selectedItem.name + " ?"),
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
                        Navigator.pop(context);
                        _picturesListBloc.dispatch(PicturesListEventDeletePicture(selectedItem.parents[0], selectedItem.id));
                        picturesList.updateSelected(false);
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
      ],
      leading: IconButton(
        icon: new Icon(Icons.cancel),
        color: textColor,
        iconSize: 30.0,
        onPressed: (){
          picturesList.updateSelected(false);
        },
        highlightColor: Colors.white30,
        splashColor: Colors.white30,
      ),
    );
  }
}