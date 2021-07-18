import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

class Settings extends StatefulWidget {
  final Preferences preferences;

  Settings(this.preferences);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _versionPressed = 0;

  @override
  void setState(state) {
    if (mounted) {
      super.setState(state);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.preferences == null) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text('Settings'),
        ),
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text('Settings'),
      ),
      child: Container(
        color: CupertinoColors.systemGroupedBackground,
        child: SafeArea(
          top: false,
          child: ListView(
            children: <Widget>[
              CupertinoFormSection(
                margin: EdgeInsets.only(top: 40),
                children: <Widget>[
                  CupertinoFormRow(
                    prefix: Text('Detect on launch'),
                    child: CupertinoSwitch(
                      value: widget.preferences.detectOnLaunch,
                      onChanged: (bool value) {
                        setState(() {
                          widget.preferences.update(detectOnLaunch: value);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Builder(builder: (context) {
                List<Widget> widgets = [
                  CupertinoFormRow(
                    prefix: Text('Alert for all buses'),
                    child: CupertinoSwitch(
                      value: widget.preferences.alertForAllBuses,
                      onChanged: (bool value) {
                        setState(() {
                          widget.preferences.update(alertForAllBuses: value);
                        });
                      },
                    ),
                  )
                ];

                if (!widget.preferences.alertForAllBuses) {
                  widget.preferences.targetBuses
                      .asMap()
                      .forEach((index, value) {
                    widgets.add(CupertinoFormRow(
                      prefix: CupertinoButton(
                        child: Icon(
                          CupertinoIcons.minus_circle_fill,
                          color: CupertinoColors.systemRed,
                          size: 30,
                        ),
                        minSize: 0,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          List<String> targetBuses =
                              widget.preferences.targetBuses;
                          targetBuses.removeAt(index);

                          setState(() {
                            widget.preferences.update(targetBuses: targetBuses);
                          });
                        },
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 2, 5, 2),
                        child: CupertinoTextField(
                          controller: TextEditingController(text: value),
                          maxLength: 8,
                          placeholder: 'Enter bus number',
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (newValue) {
                            List<String> targetBuses =
                                widget.preferences.targetBuses;
                            targetBuses[index] = newValue.toUpperCase();

                            widget.preferences.update(targetBuses: targetBuses);
                          },
                        ),
                      ),
                    ));
                  });

                  widgets.add(GestureDetector(
                    child: Container(
                      child: CupertinoFormRow(
                        prefix: Icon(
                          CupertinoIcons.plus_circle_fill,
                          color: CupertinoColors.systemGreen,
                          size: 30,
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 8, 5, 8),
                          alignment: Alignment.centerLeft,
                          child: Text('Add bus number'),
                        ),
                      ),
                      color: CupertinoColors.white,
                    ),
                    onTap: () {
                      List<String> targetBuses = widget.preferences.targetBuses;
                      targetBuses.add('');

                      setState(() {
                        widget.preferences.update(targetBuses: targetBuses);
                      });
                    },
                  ));
                }

                return CupertinoFormSection(
                  margin: EdgeInsets.only(top: 30),
                  children: widgets,
                );
              }),
              CupertinoFormSection(
                margin: EdgeInsets.only(top: 30),
                children: <Widget>[
                  CupertinoFormRow(
                    prefix: Text('Auditory feedback'),
                    child: CupertinoSwitch(
                      value: widget.preferences.auditoryFeedback,
                      onChanged: (bool value) {
                        setState(() {
                          widget.preferences.update(auditoryFeedback: value);
                        });
                      },
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Text('Vibration'),
                    child: CupertinoSwitch(
                      value: widget.preferences.vibration,
                      onChanged: (bool value) {
                        setState(() {
                          widget.preferences.update(vibration: value);
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      child: CupertinoFormRow(
                        prefix: Text('Bus font size'),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.preferences.busFontSize[0]
                                          .toUpperCase() +
                                      widget.preferences.busFontSize
                                          .split(RegExp(r'(?=[A-Z])'))
                                          .join(' ')
                                          .toLowerCase()
                                          .substring(1),
                                style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                CupertinoIcons.chevron_forward,
                                size: 24,
                                color: CupertinoColors.systemGrey3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      color: CupertinoColors.white,
                    ),
                    onTap: () async {
                      String busFontSize = await showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoActionSheet(
                            title: Text('Choose bus font size'),
                            actions: [
                              CupertinoActionSheetAction(
                                child: Text('Small'),
                                onPressed: () {
                                  Navigator.of(context).pop('small');
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text('Medium'),
                                onPressed: () {
                                  Navigator.of(context).pop('medium');
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text('Large'),
                                onPressed: () {
                                  Navigator.of(context).pop('large');
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text('Very large'),
                                onPressed: () {
                                  Navigator.of(context).pop('veryLarge');
                                },
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text('Cancel'),
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(widget.preferences.busFontSize);
                              },
                            ),
                          );
                        },
                      );

                      setState(() {
                        widget.preferences.update(busFontSize: busFontSize);
                      });
                    },
                  ),
                ],
              ),
              Builder(builder: (context) {
                if (!widget.preferences.developerMode) {
                  return Container();
                }

                return CupertinoFormSection(
                  margin: EdgeInsets.only(top: 30),
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        child: CupertinoFormRow(
                          prefix: Text('Image quality'),
                          helper: Text(
                            'Changing this requires app restart',
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  widget.preferences.imageQuality[0]
                                          .toUpperCase() +
                                      widget.preferences.imageQuality
                                          .split(RegExp(r'(?=[A-Z])'))
                                          .join(' ')
                                          .toLowerCase()
                                          .substring(1),
                                  style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 24,
                                  color: CupertinoColors.systemGrey3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        color: CupertinoColors.white,
                      ),
                      onTap: () async {
                        String imageQuality = await showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              title: Text('Choose image quality'),
                              actions: [
                                CupertinoActionSheetAction(
                                  child: Text('Low'),
                                  onPressed: () {
                                    Navigator.of(context).pop('low');
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Medium'),
                                  onPressed: () {
                                    Navigator.of(context).pop('medium');
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('High'),
                                  onPressed: () {
                                    Navigator.of(context).pop('high');
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Very high'),
                                  onPressed: () {
                                    Navigator.of(context).pop('veryHigh');
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Ultra high'),
                                  onPressed: () {
                                    Navigator.of(context).pop('ultraHigh');
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Max'),
                                  onPressed: () {
                                    Navigator.of(context).pop('max');
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: Text('Cancel'),
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(widget.preferences.imageQuality);
                                },
                              ),
                            );
                          },
                        );

                        setState(() {
                          widget.preferences.update(imageQuality: imageQuality);
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        child: CupertinoFormRow(
                          prefix: Text(
                            'Clear all app data',
                            style: TextStyle(color: CupertinoColors.systemRed),
                          ),
                          child: SizedBox(height: 36),
                        ),
                        color: CupertinoColors.white,
                      ),
                      onTap: () {
                        setState(() {
                          widget.preferences.clear();
                        });

                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text('Alert'),
                            content: Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'All app data cleared.',
                                style: TextStyle(fontSize: 15),
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
                    ),
                  ],
                );
              }),
              CupertinoFormSection(
                margin: EdgeInsets.only(top: 30),
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      child: CupertinoFormRow(
                        prefix: Text('Welcome'),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Icon(
                            CupertinoIcons.chevron_forward,
                            size: 24,
                            color: CupertinoColors.systemGrey3,
                          ),
                        ),
                      ),
                      color: CupertinoColors.white,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('welcome', (route) => false);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      child: CupertinoFormRow(
                        prefix: Text('About app'),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Icon(
                            CupertinoIcons.chevron_forward,
                            size: 24,
                            color: CupertinoColors.systemGrey3,
                          ),
                        ),
                      ),
                      color: CupertinoColors.white,
                    ),
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('About'),
                          content: Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'An app made by a group of students from Raffles Institution for their Innovation Programme (IvP) project.\n\nSpecial thanks to the teacher-mentor, Mr Justin Yap and SUTD mentors Dr Anariba and Ms Vanessa Chia.\n\n© 2021 Han Cen, Lachlan Goh, Jerome Thio',
                              style: TextStyle(fontSize: 15),
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
                  ),
                  GestureDetector(
                    child: Container(
                      child: CupertinoFormRow(
                        prefix: Text('Version'),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                          child: Text(
                            VERSION,
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                        ),
                      ),
                      color: CupertinoColors.white,
                    ),
                    onTapDown: (_) {
                      setState(() {
                        _versionPressed = DateTime.now().millisecondsSinceEpoch;
                      });
                    },
                    onTapUp: (details) {
                      int now = DateTime.now().millisecondsSinceEpoch;
                      int pressed = _versionPressed;

                      setState(() {
                        _versionPressed = 0;
                      });

                      if (widget.preferences.developerMode) {
                        return;
                      }

                      if ((now - pressed - 7000).abs() > 1000) {
                        return;
                      }

                      setState(() {
                        widget.preferences.update(developerMode: true);
                      });

                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('Alert'),
                          content: Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Developer mode enabled.',
                              style: TextStyle(fontSize: 15),
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
                  ),
                  GestureDetector(
                    child: Container(
                      child: CupertinoFormRow(
                        prefix: Text(
                          'Source code',
                          style: TextStyle(color: CupertinoColors.systemBlue),
                        ),
                        child: SizedBox(height: 36),
                      ),
                      color: CupertinoColors.white,
                    ),
                    onTap: () {
                      launch(REPO_URL);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '© 2021 Han Cen, Lachlan Goh, Jerome Thio',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
