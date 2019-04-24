import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/UI/Onboarding/dot_indicators.dart';
import 'package:flutter_drive_filer/UI/Onboarding/page.dart';
import 'package:flutter_drive_filer/ui/login/sign_in.dart';

class OnboardingMainPage extends StatefulWidget {
  static String tag = 'onboarding-page';
  @override
  _OnboardingMainPageState createState() => new _OnboardingMainPageState();
}

class _OnboardingMainPageState extends State<OnboardingMainPage> {
  final _controller = new PageController();
  final List<Widget> _pages = [
    new Page(
      'Take pictures',
      'Take a picture of anything you want to save from your class',
      'assets/camera.png',
      LinearGradient(
          colors: [
            Colors.red[200],
            Colors.red[600],
            Colors.red[900],
          ],
          begin: Alignment(0.5, -1.0),
          end: Alignment(0.5, 1.0)
      ),
      170.0,
      170.0,
    ),
    new Page(
      'Organize in folders',
      'Organize all of your pictures in folders for different courses and classes',
      'assets/picturefolder.png',
      LinearGradient(
          colors: [
            Colors.purple[200],
            Colors.deepPurple[600],
            Colors.deepPurple[900],
          ],
          begin: Alignment(0.5, -1.0),
          end: Alignment(0.5, 1.0)),
      170.0,
      170.0,
    ),
    new Page(
      'Save everything',
      'Save all the pictures that you take in your Google Drive account',
      'assets/googledrive.png',
      LinearGradient(
          colors: [
            Colors.lightBlue[200],
            Colors.blue[600],
            Colors.blue[900],
          ],
          begin: Alignment(0.5, -1.0),
          end: Alignment(0.5, 1.0)
      ),
      170.0,
      170.0,
    ),
  ];

  int page = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDone = page == _pages.length - 1;
    return new Scaffold(
        backgroundColor: Colors.transparent,
        body: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new PageView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
                onPageChanged: (int p) {
                  setState(() {
                    page = p;
                  });
                },
              ),
            ),

            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: new SafeArea(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  primary: false,
                  titleSpacing: 0.0,
                  automaticallyImplyLeading: false,
                  // Don't show the leading button

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text(page >= 1 ? 'BACK' : '',
                          style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          if (page >= 1) {
                            _controller.animateToPage(
                                page - 1, duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          }
                        },
                      ),
                    ],
                  ),

                  actions: <Widget>[
                    FlatButton(
                      child: Text(isDone ? 'DONE' : 'NEXT',
                        style: TextStyle(color: Colors.white),),
                      onPressed: isDone ? () {
                        //Navigator.pushReplacementNamed(context, '/login');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                      } : () {
                        _controller.animateToPage(
                            page + 1, duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                    ),
                  ],
                ),
              ),
            ),
            new Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: new SafeArea(
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new DotsIndicator(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageSelected: (int page) {
                          _controller.animateToPage(
                            page,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                          width: 150.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(30.0),
                            border: Border.all(color: Colors.white, width: 1.0),
                            color: Colors.transparent,
                          ),
                          child: new Material(
                            child: MaterialButton(
                              child: Text('START',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                              },
                              highlightColor: Colors.white30,
                              splashColor: Colors.white30,
                            ),
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}