import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drive_filer/ui/res/folder_colors.dart';

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

  var selectedColor;

  ColorPicker(this.selectedColor);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.count(
        crossAxisCount: 6,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Asparagus; Navigator.pop(context);},
            color: HexColor(FolderColors.Asparagus),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Blue_velvet; Navigator.pop(context);},
            color: HexColor(FolderColors.Blue_velvet),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Bubble_gum; Navigator.pop(context);},
            color: HexColor(FolderColors.Bubble_gum),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Cardinal; Navigator.pop(context);},
            color: HexColor(FolderColors.Cardinal),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Chocolate_ice_cream; Navigator.pop(context);},
            color: HexColor(FolderColors.Chocolate_ice_cream),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Denim; Navigator.pop(context);},
            color: HexColor(FolderColors.Denim),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Desert_sand; Navigator.pop(context);},
            color: HexColor(FolderColors.Desert_sand),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Earthworm; Navigator.pop(context);},
            color: HexColor(FolderColors.Earthworm),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Macaroni; Navigator.pop(context);},
            color: HexColor(FolderColors.Macaroni),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Mars_orange; Navigator.pop(context);},
            color: HexColor(FolderColors.Mars_orange),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Mountain_grey; Navigator.pop(context);},
            color: HexColor(FolderColors.Mountain_grey),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Mouse; Navigator.pop(context);},
            color: HexColor(FolderColors.Mouse),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Old_brick_red; Navigator.pop(context);},
            color: HexColor(FolderColors.Old_brick_red),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Pool; Navigator.pop(context);},
            color: HexColor(FolderColors.Pool),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Purple_dino; Navigator.pop(context);},
            color: HexColor(FolderColors.Purple_dino),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Purple_rain; Navigator.pop(context);},
            color: HexColor(FolderColors.Purple_rain),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Rainy_sky; Navigator.pop(context);},
            color: HexColor(FolderColors.Rainy_sky),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Sea_foam; Navigator.pop(context);},
            color: HexColor(FolderColors.Sea_foam),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Slime_green; Navigator.pop(context);},
            color: HexColor(FolderColors.Slime_green),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Spearmint; Navigator.pop(context);},
            color: HexColor(FolderColors.Spearmint),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Toy_eggplant; Navigator.pop(context);},
            color: HexColor(FolderColors.Toy_eggplant),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Vern_fern; Navigator.pop(context);},
            color: HexColor(FolderColors.Vern_fern),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Wild_straberries; Navigator.pop(context); },
            color: HexColor(FolderColors.Wild_straberries),
          ),
          RaisedButton(
            shape: CircleBorder(),
            onPressed: (){ selectedColor = FolderColors.Yellow_cab; Navigator.pop(context); },
            color: HexColor(FolderColors.Yellow_cab),
          ),
        ],
      )
    );
  }
}