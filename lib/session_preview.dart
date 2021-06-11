import './main.dart';
import './create_session.dart';
import './swipe_back_detector.dart';
import './create_workout.dart';
import './sprinting_session.dart';

import 'package:flutter/material.dart';


class SessionPreview extends StatefulWidget {
  final String sessionName;
  String sessionType;

  SessionPreview(this.sessionName, this.sessionType);

  @override
  _SessionPreviewState createState() => _SessionPreviewState();
}

class _SessionPreviewState extends State<SessionPreview> {
  Map<String, bool> checkboxValues = {};
  Widget parentWindow;

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
    List<String> exercisesList;

    if (widget.sessionType == 'Workout') {
      exercisesList = AppGlobals.workoutList;
    } else if (widget.sessionType == 'Session') {
      exercisesList = AppGlobals.exercisesList;
    } else if (widget.sessionType == 'Sprints') {
      exercisesList = AppGlobals.sprintDistances.map(
        (e) {
          if (e == -1) {
            return 'Rest Period';
          } else {
            return '${e.round().toString()} m';
          }
        },
      ).toList();
    }

    for (String exercise in exercisesList) {
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
  void initState() {
    super.initState();
    if (widget.sessionType == 'Workout') {
      parentWindow = CreateWorkout();
    } else if (widget.sessionType == 'Session') {
      parentWindow = CreateSession();
    } else if (widget.sessionType == 'Sprints') {
      parentWindow = SprintingSession();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                parentWindow,
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
                    if (widget.sessionType == 'Workout') {
                      for (String key in checkboxValues.keys) {
                        if (checkboxValues[key] == true) {
                          setState(
                            () {
                              int exerciseIndex =
                                  AppGlobals.workoutList.indexOf(key);
                              AppGlobals.workoutDurations.remove(
                                  AppGlobals.workoutDurations[exerciseIndex]);
                              AppGlobals.workoutList.remove(key);
                            },
                          );
                        }
                      }

                      if (AppGlobals.workoutList.length == 0) {
                        GlobalFunctions.navigate(
                          context,
                          CreateWorkout(),
                        );
                      }
                    } else if (widget.sessionType == 'Session') {
                      for (String key in checkboxValues.keys) {
                        if (checkboxValues[key] == true) {
                          setState(
                            () {
                              int exerciseIndex =
                                  AppGlobals.exercisesList.indexOf(key);
                              AppGlobals.exerciseDurations.remove(
                                  AppGlobals.exerciseDurations[exerciseIndex]);
                              AppGlobals.exercisesList.remove(key);
                            },
                          );
                        }
                      }

                      if (AppGlobals.exercisesList.length == 0) {
                        GlobalFunctions.navigate(
                          context,
                          CreateSession(),
                        );
                      }
                    } else if (widget.sessionType == 'Sprints') {
                      for (String key in checkboxValues.keys) {
                        if (checkboxValues[key] == true) {
                          double distance;

                          if (key != 'Rest Period') {
                            distance = double.parse(key.split(' ')[0]);
                          } else {
                            distance = -1;
                          }

                          setState(
                            () {
                              int exerciseIndex =
                                  AppGlobals.sprintDistances.indexOf(distance);
                              AppGlobals.exerciseDurations.remove(
                                  AppGlobals.exerciseDurations[exerciseIndex]);
                              AppGlobals.sprintDistances.remove(distance);
                            },
                          );
                        }
                      }

                      if (AppGlobals.sprintDistances.length == 0) {
                        GlobalFunctions.navigate(
                          context,
                          SprintingSession(),
                        );
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
