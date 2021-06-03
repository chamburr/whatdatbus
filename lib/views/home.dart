import 'package:flutter/cupertino.dart';

import '../constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(TITLE),
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.info),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text('About'),
                content: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    '$TITLE $VERSION\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sed dui facilisis, sodales tortor id, lacinia justo. Nunc sagittis luctus mi, vitae posuere libero rutrum sed. Nam eu malesuada sem. Pellentesque in leo sit amet justo aliquet eleifend. Vivamus facilisis facilisis feugiat.\n\n© 2021 COOL PERSON',
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
          padding: EdgeInsets.zero,
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 40),
                Text(
                  'Welcome to $TITLE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sed dui facilisis, sodales tortor id, lacinia justo.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Text(
                  'How it works',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.camera, size: 40),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Blah blah',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Use your camera to blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.hourglass, size: 40),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Blah blah',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Do some magic to blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.chat_bubble_text, size: 40),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Blah blah',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Tell you the blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  'This app uses your blah blah blah and blah blah blah blah blah blah blah blah blah blah blah and surprise it uses your camera',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CupertinoButton.filled(
                  child: Text('Start Detection'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/live');
                  },
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
