import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/Onboarding/circles_with_image.dart';

class Page extends StatelessWidget {

  final String tittle;
  final String body;
  final String image;
  final Gradient gradient;
  final double height;
  final double width;

  Page({
    this.tittle,
    this.body,
    this.image,
    this.gradient,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: double.infinity,
      width: double.infinity,
      decoration: new BoxDecoration(
          gradient: gradient,
      ),
      child: Stack(
        children: <Widget>[
          new Positioned(
            child: new CircleWithImage(),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
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
                    style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  body,
                  style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
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