import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/ui/res/color_tools.dart';
import 'package:googleapis/drive/v3.dart';

class HomeChooseFolder extends StatefulWidget {

  final List<File> allItemsList;

  HomeChooseFolder(this.allItemsList);

  _HomeChooseFolderState createState() => _HomeChooseFolderState(allItemsList);
}

class _HomeChooseFolderState extends State<HomeChooseFolder> {

  var searched = false;
  var searchedList;
  var allItemsList;
  var searchFocused = false;

  _HomeChooseFolderState(this.allItemsList);


  Future<bool> _onWillPop() async{
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
                  child: Text("Do you want to return without saving the picture?"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context, false);
              },
              child: Text("No", style: TextStyle(color: Colors.red),),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pop(context, true);
              },
              child: Text("Yes"),
            ),
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    final textColor = Colors.black54;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          titleSpacing: 0.0,
          title: Text("Choose the course to save the picture"
          , style: Theme.of(context).textTheme.body1.copyWith(color: textColor, fontWeight: FontWeight.bold),),
          actions: <Widget>[
          ],
        ),
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
              child: Builder(
                builder: (BuildContext context){
                  var itemsList;
                  if(searched && searchedList != null){
                    itemsList = searchedList;
                  }else{
                    itemsList = allItemsList;
                  }
                  return Container(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemsList.length,
                      itemBuilder: (context, index) {
                        return ListBody(
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                Navigator.pop(context, itemsList[index].id);
                              },
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
                                        color: HexColor(itemsList[index].folderColorRgb),
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: ((MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/2),
                                              child: Text(
                                                itemsList[index].name,
                                                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold,),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                              ),
                                            )
                                          ),
                                          Center(
                                            child: Container(
                                              alignment:Alignment.center,
                                              margin: EdgeInsets.only(top: 10.0),
                                              width: ((MediaQuery.of(context).size.width- ((MediaQuery.of(context).size.width/15) *2))/2),
                                              child: Text(
                                                (itemsList[index].description != null) ? itemsList[index].description : 'No description.',
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
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
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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