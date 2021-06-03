import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';
import 'views/home.dart';
import 'views/live.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();

  runApp(CupertinoApp(
    title: TITLE,
    debugShowCheckedModeBanner: false,
    theme: CupertinoThemeData(
      brightness: Brightness.light,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/live': (context) => Live(cameras),
    },
  ));
}
