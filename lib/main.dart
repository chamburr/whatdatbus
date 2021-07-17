import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'views/home.dart';
import 'views/settings.dart';
import 'views/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Preferences preferences = await getPreferences();
  String route = preferences.welcomeShown ? 'home' : 'welcome';

  runApp(CupertinoApp(
    title: TITLE,
    debugShowCheckedModeBanner: false,
    theme: CupertinoThemeData(
      brightness: Brightness.light,
    ),
    initialRoute: route,
    routes: {
      '/': (context) => null,
      'home': (context) => Home(cameras, preferences),
      'settings': (context) => Settings(preferences),
      'welcome': (context) => Welcome(preferences),
    },
  ));
}
