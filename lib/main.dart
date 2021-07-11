import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'views/home.dart';
import 'views/live.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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
