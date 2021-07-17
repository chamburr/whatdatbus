import 'package:flutter/cupertino.dart';

import '../config.dart';

class Welcome extends StatefulWidget {
  final Preferences preferences;

  Welcome(this.preferences);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/icons/icon.png'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  TITLE,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'This app helps you to board the bus by actively telling you what buses are currently in front of you.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'How it works',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                                'Video Tracking',
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
                                'Do some magic to detect the bus number.',
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
                                'Tell you the bus number found by reading it out.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'This app uses your camera continuously while you are on the detection page. We never upload or store your videos anywhere.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Tip: Double tap to pause bus detection.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CupertinoButton.filled(
                  child: Text('Start Detection'),
                  onPressed: () async {
                    await widget.preferences.update(welcomeShown: true);
                    Navigator.of(context).pushReplacementNamed('home');
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
