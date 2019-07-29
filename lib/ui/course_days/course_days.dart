import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drive_filer/bloc/course_days_bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_events.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_states.dart';
import 'package:flutter_drive_filer/ui/pictures_list/pictures_list.dart';
import 'package:flutter_drive_filer/ui/res/color_tools.dart';
import 'package:flutter_drive_filer/ui/res/folder_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class CourseDays extends StatefulWidget {

  final GoogleSignInAccount _account;
  final File course;

  CourseDays(this._account, this.course);

  _CourseDaysState createState() => _CourseDaysState(_account, course);
}

class _CourseDaysState extends State<CourseDays> {

  CourseDaysBloc _courseDaysBloc;
  GoogleSignInAccount _account;
  File _course;

  _CourseDaysState(this._account, this._course);

  var selectedItem;
  var selected = false;
  var folderSelectedColor = FolderColors.Rainy_sky;
  var searched = false;
  var searchedList;
  var allItemsList;
  var searchFocused = false;


  @override
  void initState() {
    super.initState();
    _courseDaysBloc = CourseDaysBloc(GoogleDriveRepository(_account));
    _courseDaysBloc.dispatch(CourseDaysEventListFolders(_course.id));
  }

  @override
  void dispose(){
    super.dispose();
    _courseDaysBloc.dispose();
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
    }else if(searchFocused){
      FocusScope.of(context).unfocus();
      searchFocused = false;
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

    return BlocProvider<CourseDaysBloc>(
      bloc: _courseDaysBloc,
      child: WillPopScope(

        onWillPop: _onWillPop,

        child: Scaffold(

          appBar: (selected) ? MySelectedAppbar(textColor, _courseDaysBloc, selectedColor, this, selectedItem).build(context) : MyAppbar(textColor, _courseDaysBloc, this).build(this.context),

          body: Column(

            children: <Widget>[
              //Searcher
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTap: (){
                    searchFocused = true;
                    setState(() { });
                  },
                  autofocus: false,
                  onChanged: (value) {
                    if(value.isNotEmpty && allItemsList != null){
                      searchedList =  filterSearchResults(value, allItemsList);
                      searched = true;
                      setState(() { });
                    }
                    else{
                      searched = false;
                      setState(() { });
                    }
                  },
                  controller: null,
                  decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                      borderRadius: BorderRadius.all(Radius.circular(25.0))
                    ),
                  ),
                ),
              ),

              Expanded(
                child: BlocBuilder<CourseDaysEvent,CourseDaysState>(
                  bloc: _courseDaysBloc,
                  builder: (BuildContext context, CourseDaysState state){

                    if(state is CourseDaysStateDefault){
                      return Center(
                        child: RaisedButton(
                          child: const Text('Refresh'),
                          onPressed: (){
                            _courseDaysBloc.dispatch(CourseDaysEventListFolders(_course.id));
                          },
                        ),
                      );
                    }

                    if(state is CourseDaysStateLoading){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if(state is CourseDaysStateError){
                      return Center(
                        child: Text(
                          'Connection error!',
                          style: TextStyle(color: Colors.red, fontSize: 24.0),
                        ),
                      );
                    }

                    if(state is CourseDaysStateSearched){
                      var itemsList;
                      allItemsList = state.files;
                      if(searched && searchedList != null){
                        itemsList = searchedList;
                      }else{
                        itemsList = state.files;
                      }


                      if(itemsList.length == 0){
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
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                shrinkWrap: true,
                                itemCount: itemsList.length,
                                itemBuilder: (context, index) {
                                      return InkWell(
                                        onLongPress: (){
                                          setState((){
                                            selectedItem = itemsList[index];
                                            selected = true;
                                          });
                                        },
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PicturesList(_account, itemsList[index])));
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
                                                child: Icon(
                                                  Icons.folder,
                                                  size: ((MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/3),
                                                  color: HexColor(itemsList[index].folderColorRgb),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    itemsList[index].name,
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
                                            color: (selectedItem != null && selectedItem == itemsList[index])? selectedColor : Colors.grey[100],
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
  final CourseDaysBloc _courseDaysBloc;
  final _CourseDaysState courseDays;

  MyAppbar(this.textColor, this._courseDaysBloc, this.courseDays);

  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      titleSpacing: 0.0,
      title: Text(
        courseDays._course.name,
        style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
        ),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.refresh),
          color: textColor,
          iconSize: 30.0,
          onPressed: (){
            _courseDaysBloc.dispatch(CourseDaysEventListFolders(courseDays._course.id));
          },
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
        new IconButton(
          icon: new Icon(Icons.camera_alt),
          color: textColor,
          iconSize: 30.0,
          onPressed: (){
            _courseDaysBloc.dispatch(CourseDaysEventTakePicture(courseDays.allItemsList, courseDays._course.id, context));
          },
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
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
  final CourseDaysBloc _courseDaysBloc;
  final Color selectedColor;
  final File selectedItem;
  final _CourseDaysState courseDays;
  MySelectedAppbar(this.textColor, this._courseDaysBloc, this.selectedColor, this.courseDays, this.selectedItem);

  Widget build(BuildContext context) {

    return AppBar(
      centerTitle: true,
      backgroundColor: selectedColor,
      elevation: 0.0,
      titleSpacing: 0.0,
      title: Text(selectedItem.name, style: Theme.of(context).textTheme.title.copyWith(color: textColor, fontWeight: FontWeight.bold),),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.color_lens),
          color: textColor,
          iconSize: 30.0,
          onPressed: (){
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context){
                return ColorPickerCourse(selectedItem.folderColorRgb, selectedItem, _courseDaysBloc, context);
              }
            );
            courseDays.updateSelected(false);
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
                        _courseDaysBloc.dispatch(CourseDaysEventDeleteFolder(selectedItem.parents[0], selectedItem.id));
                        courseDays.updateSelected(false);
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
          courseDays.updateSelected(false);
        },
        highlightColor: Colors.white30,
        splashColor: Colors.white30,
      ),
    );
  }
}

List<File> filterSearchResults(String query, List<File>items) {
    List<File> searchedList = List<File>();
    items.forEach((item){
      print(item.name);
      print(query);
      if(item.name.toLowerCase().contains(query.toLowerCase())){
        searchedList.add(item);
      }
    });
    return searchedList;
}
