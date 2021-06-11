import 'package:ultimate_translator/main.dart';

import './create_session.dart';
import './swipe_back_detector.dart';

import 'package:flutter/material.dart';

class SessionPreview extends StatefulWidget {
  final String sessionName;

  SessionPreview(this.sessionName);

  @override
  _SessionPreviewState createState() => _SessionPreviewState();
}

class _SessionPreviewState extends State<SessionPreview> {
  Map<String, bool> checkboxValues = {};

  int getCheckedBoxes() {
    int checked = 0;

    for (String key in checkboxValues.keys) {
      if (checkboxValues[key] == true) {
        checked++;
      }
    }

    return checked;
  }

  List<Widget> getExercises() {
    List<Widget> exerciseRows = [];

    for (String exercise in AppGlobals.exercisesList) {
      if (!checkboxValues.keys.contains(exercise)) {
        checkboxValues[exercise] = false;
      }

      exerciseRows.add(
        Container(
          alignment: Alignment.center,
          child: CheckboxListTile(
            checkColor: Colors.redAccent,
            activeColor: Colors.greenAccent,
            tileColor: Colors.black,
            value: checkboxValues[exercise],
            onChanged: (bool value) {
              setState(
                () {
                  checkboxValues[exercise] = value;
                },
              );
            },
            title: Text(
              exercise,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                fontFamily: 'PermanentMarker',
              ),
            ),
          ),
        ),
      );
    }

    return exerciseRows;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.sessionName);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.01,
              left: 0,
              right: 0,
              child: SwipeBackDetector(
                CreateSession(),
                child: Text(
                  (widget.sessionName != '') ? widget.sessionName : 'Session',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.25,
              left: 0,
              right: 0,
              bottom: DeviceInfo.deviceHeight(context) * 0.1,
              child: SingleChildScrollView(
                child: Column(
                  children: getExercises(),
                ),
              ),
            ),
            if (getCheckedBoxes() > 0)
              Positioned(
                top: DeviceInfo.deviceHeight(context) * 0.85,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: () {
                    for (String key in checkboxValues.keys) {
                      if (checkboxValues[key] == true) {
                        if (AppGlobals.exercisesList.length > 1) {
                          setState(
                                () {
                              int exerciseIndex =
                              AppGlobals.exercisesList.indexOf(key);
                              AppGlobals.exerciseDurations.remove(
                                  AppGlobals.exerciseDurations[exerciseIndex]);
                              AppGlobals.exercisesList.remove(key);
                            },
                          );
                        }else{
                          setState(() {
                            AppGlobals.exercisesList = [];
                            AppGlobals.exerciseDurations = [];
                          });
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: DeviceInfo.deviceWidth(context) * 0.15,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
