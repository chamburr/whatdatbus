import 'package:shared_preferences/shared_preferences.dart';

const TITLE = 'WhatDatBus';
const VERSION = '0.1.0';
const REPO_URL = 'https://github.com/chamburr/whatdatbus';

class Preferences {
  SharedPreferences _preferences;

  bool welcomeShown;
  bool detectOnLaunch;
  bool alertForAllBuses;
  List<String> targetBuses;
  bool auditoryFeedback;
  bool vibration;
  String busFontSize;
  bool developerMode;
  String imageQuality;

  Preferences(SharedPreferences preferences) {
    this._preferences = preferences;

    init();
  }

  void init() {
    welcomeShown = _preferences.getBool('welcomeShown') ?? false;
    detectOnLaunch = _preferences.getBool('detectOnLaunch') ?? true;
    alertForAllBuses = _preferences.getBool('alertForAllBuses') ?? true;
    targetBuses = _preferences.getStringList('targetBuses') ?? [];
    auditoryFeedback = _preferences.getBool('auditoryFeedback') ?? true;
    vibration = _preferences.getBool('vibration') ?? false;
    busFontSize = _preferences.getString('busFontSize') ?? 'large';
    developerMode = _preferences.getBool('developerMode') ?? false;
    imageQuality = _preferences.getString('imageQuality') ?? 'veryHigh';
  }

  Future<void> update(
      {bool welcomeShown,
      bool detectOnLaunch,
      bool alertForAllBuses,
      List<String> targetBuses,
      bool auditoryFeedback,
      bool vibration,
      String busFontSize,
      bool developerMode,
      String imageQuality}) async {
    if (welcomeShown != null) {
      this.welcomeShown = welcomeShown;
      await _preferences.setBool('welcomeShown', welcomeShown);
    }

    if (detectOnLaunch != null) {
      this.detectOnLaunch = detectOnLaunch;
      await _preferences.setBool('detectOnLaunch', detectOnLaunch);
    }

    if (alertForAllBuses != null) {
      this.alertForAllBuses = alertForAllBuses;
      await _preferences.setBool('alertForAllBuses', alertForAllBuses);
    }

    if (targetBuses != null) {
      this.targetBuses = targetBuses;
      await _preferences.setStringList('targetBuses', targetBuses);
    }

    if (auditoryFeedback != null) {
      this.auditoryFeedback = auditoryFeedback;
      await _preferences.setBool('auditoryFeedback', auditoryFeedback);
    }

    if (vibration != null) {
      this.vibration = vibration;
      await _preferences.setBool('vibration', vibration);
    }

    if (busFontSize != null) {
      this.busFontSize = busFontSize;
      await _preferences.setString('busFontSize', busFontSize);
    }

    if (developerMode != null) {
      this.developerMode = developerMode;
      await _preferences.setBool('developerMode', developerMode);
    }

    if (imageQuality != null) {
      this.imageQuality = imageQuality;
      await _preferences.setString('imageQuality', imageQuality);
    }
  }

  Future<void> reload() async {
    await _preferences.reload();
    init();
  }

  Future<void> clear() async {
    await _preferences.clear();
    init();
  }
}

Future<Preferences> getPreferences() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Preferences preferences = Preferences(sharedPreferences);

  return preferences;
}
