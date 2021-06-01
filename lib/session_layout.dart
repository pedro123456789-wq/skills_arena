import './main.dart';
import './session_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SessionLayout extends StatelessWidget {
  final String sessionName;
  final List exercises;
  final bool isWorkout;
  final bool showStart;

  SessionLayout({
    @required this.sessionName,
    @required this.exercises,
    @required this.isWorkout,
    this.showStart = true,
  });

  List<Widget> exerciseWidgets(BuildContext context) {
    List<Widget> exerciseLabels = [];

    for (int i = 0; i < exercises.length; i++) {
      String exercise = exercises[i].split(',')[0];
      int totalSeconds = int.parse(exercises[i].split(',')[1]);
      int durationMinutes = totalSeconds ~/ 60;
      int durationSeconds = totalSeconds - (durationMinutes * 60);

      exerciseLabels.add(
        Container(
          padding: EdgeInsets.fromLTRB(
            0,
            DeviceInfo.deviceHeight(context) * 0.07,
            0,
            0,
          ),
          child: Text(
            '$exercise: \n ${GlobalFunctions.timeString(durationMinutes, durationSeconds)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: DeviceInfo.deviceWidth(context) * 0.06,
              fontFamily: 'PermanentMarker',
            ),
          ),
        ),
      );
    }

    return exerciseLabels;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              top: DeviceInfo.deviceWidth(context) * 0.01,
              left: 0,
              right: 0,
              child: Text(
                sessionName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.1,
              left: 0,
              right: 0,
              bottom: DeviceInfo.deviceHeight(context) * 0.15,
              child: SingleChildScrollView(
                child: Column(
                  children: exerciseWidgets(context),
                ),
              ),
            ),
            if (showStart == true)
              Positioned(
                top: DeviceInfo.deviceHeight(context) * 0.85,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: () {
                    GlobalFunctions.navigate(
                      context,
                      SessionManager(exercises, isWorkout, false),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text(
                    (isWorkout == false) ? 'Start Session' : 'Start Workout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                      fontFamily: 'PermanentMarker',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
