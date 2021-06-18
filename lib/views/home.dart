import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  child: RichText(
                    text: TextSpan(
                      text: '$TITLE v$VERSION\n',
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: '$REPO_URL\n\n',
                          style: TextStyle(
                            color: CupertinoColors.systemBlue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://$REPO_URL/');
                            },
                        ),
                        TextSpan(
                            text:
                                'An app made by a group of students from Raffles Institution for the Innovation Programme (IvP). Special thanks to our teacher-mentor, Mr Justin Yap.\n\n© 2021 Han Cen, Lachlan Goh, Jerome Thio')
                      ],
                    ),
                    textAlign: TextAlign.center,
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
                  'This app aim to solve the problems that visually-impaired persons might face when boarding the bus by telling them what buses are currently in front of them',
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
                                'Video Feed',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Use your camera to track buses in front of you.',
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
                                'Bus Detection',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Do some magic to detect the bus\' number.',
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
                                'Auditory Guide',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Tell you the bus number with Text-To-Speech.',
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
                  'This app uses your camera and will continuously use it when you are on the detection page. We never upload or store your videos anywhere as it is all processed on the device.',
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
