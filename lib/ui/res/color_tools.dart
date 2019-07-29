import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drive_filer/bloc/course_days_bloc.dart';
import 'package:flutter_drive_filer/bloc/home_bloc.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_events.dart';
import 'package:flutter_drive_filer/ui/home/home_events.dart';
import 'package:flutter_drive_filer/ui/res/folder_colors.dart';
import 'package:googleapis/drive/v3.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ColorPicker extends StatelessWidget {

  final String selectedColor;
  final File selectedItem;
  final HomeBloc _homeBloc;
  final context;

  ColorPicker(this.selectedColor, this.selectedItem, this._homeBloc, this.context);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text("Pick a color"),
      content: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: 6,
          padding: EdgeInsets.all(2.0),
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            RaisedButton(
              padding: EdgeInsets.all(20.0),
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Asparagus, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Asparagus),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Blue_velvet, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Blue_velvet),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Bubble_gum, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Bubble_gum),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Cardinal, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Cardinal),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Chocolate_ice_cream, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Chocolate_ice_cream),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Denim, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Denim),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Desert_sand, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Desert_sand),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Earthworm, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Earthworm),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Macaroni, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Macaroni),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Mars_orange, selectedItem.id));
                  Navigator.pop(context);
                },
              color: HexColor(FolderColors.Mars_orange),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Mountain_grey, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Mountain_grey),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Mouse, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Mouse),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Old_brick_red, selectedItem.id));
                  Navigator.pop(context);
              },
              color: HexColor(FolderColors.Old_brick_red),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Pool, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Pool),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Purple_dino, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Purple_dino),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Purple_rain, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Purple_rain),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Rainy_sky, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Rainy_sky),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Sea_foam, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Sea_foam),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Slime_green, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Slime_green),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Spearmint, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Spearmint),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Toy_eggplant, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Toy_eggplant),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Vern_fern, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Vern_fern),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Wild_straberries, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Wild_straberries),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _homeBloc.dispatch(HomeEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Yellow_cab, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Yellow_cab),
            ),
          ],
        )
      ),
    );
  }
}

class ColorPickerCourse extends StatelessWidget {

  final String selectedColor;
  final File selectedItem;
  final CourseDaysBloc _courseDaysBloc;
  final context;

  ColorPickerCourse(this.selectedColor, this.selectedItem, this._courseDaysBloc, this.context);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text("Pick a color"),
      content: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: 6,
          padding: EdgeInsets.all(2.0),
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            RaisedButton(
              padding: EdgeInsets.all(20.0),
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Asparagus, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Asparagus),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Blue_velvet, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Blue_velvet),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Bubble_gum, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Bubble_gum),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Cardinal, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Cardinal),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Chocolate_ice_cream, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Chocolate_ice_cream),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Denim, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Denim),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Desert_sand, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Desert_sand),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Earthworm, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Earthworm),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Macaroni, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Macaroni),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Mars_orange, selectedItem.id));
                  Navigator.pop(context);
                },
              color: HexColor(FolderColors.Mars_orange),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Mountain_grey, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Mountain_grey),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Mouse, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Mouse),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Old_brick_red, selectedItem.id));
                  Navigator.pop(context);
              },
              color: HexColor(FolderColors.Old_brick_red),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Pool, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Pool),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Purple_dino, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Purple_dino),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Purple_rain, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Purple_rain),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Rainy_sky, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Rainy_sky),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Sea_foam, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Sea_foam),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Slime_green, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Slime_green),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Spearmint, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Spearmint),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Toy_eggplant, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Toy_eggplant),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Vern_fern, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Vern_fern),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                selectedItem.description, FolderColors.Wild_straberries, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Wild_straberries),
            ),
            RaisedButton(
              shape: CircleBorder(),
              onPressed: (){
                _courseDaysBloc.dispatch(CourseDaysEventUpdateFolder(selectedItem.parents[0], selectedItem.name,
                  selectedItem.description, FolderColors.Yellow_cab, selectedItem.id));
                Navigator.pop(context);
              },
              color: HexColor(FolderColors.Yellow_cab),
            ),
          ],
        )
      ),
    );
  }
}