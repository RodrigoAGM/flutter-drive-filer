import 'package:flutter/material.dart';

class Page extends StatelessWidget {

  final String tittle;
  final String body;
  final String image;
  final double height;
  final double width;

  Page(
    this.tittle,
    this.body,
    this.image,
    this.height,
    this.width,
  );

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.black45;
    return new Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          new Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Image(
                    image: AssetImage(image),
                    fit: BoxFit.fitHeight,
                  ),
                  height: height,
                  width: width,
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tittle,
                    style: Theme.of(context).textTheme.display1.copyWith(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  body,
                  style: Theme.of(context).textTheme.body1.copyWith(color: textColor),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
        alignment: FractionalOffset.center,
      ),
    );
  }
}