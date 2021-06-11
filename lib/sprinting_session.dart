import './main.dart';
import './navigation_bar.dart';
import './add_sprinting_exercise.dart';
import './add_rest.dart';
import './session_preview.dart';
import './session_manager.dart';
import './swipe_back_detector.dart';
import './physical_training.dart';

import 'package:flutter/material.dart';

class SprintingSession extends StatelessWidget {
  List<String> mergeDurations() {
    List<String> merged = [];

    for (int i = 0; i < AppGlobals.exerciseDurations.length; i++) {
      if (AppGlobals.sprintDistances[i] != -1) {
        merged.add(
            '${AppGlobals.sprintDistances[i].toInt()}m sprint, ${AppGlobals.exerciseDurations[i]}');
      } else {
        merged.add('Rest Period, ${AppGlobals.exerciseDurations[i]}');
      }
    }

    return merged;
  }

  String getTotalDuration() {
    if (AppGlobals.exerciseDurations.length > 0) {
      int totalSeconds = AppGlobals.exerciseDurations.reduce(
        (v1, v2) => v1 + v2,
      );
      int seconds = totalSeconds % 60;
      int minutes = (totalSeconds - seconds) ~/ 60;

      return GlobalFunctions.timeString(minutes, seconds);
    } else {
      return '0 seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: NavigationBar(),
        body: Stack(
          children: [
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.01,
              left: 0,
              right: 0,
              child: SwipeBackDetector(
                PhysicalTraining(),
                callback: () {
                  AppGlobals.sprintDistances = [];
                  AppGlobals.exerciseDurations = [];
                },
                child: Text(
                  'Sprinting Session',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.14,
              left: 0,
              right: 0,
              child: Text(
                'Duration: \n ${getTotalDuration()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.06,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.28,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  if (AppGlobals.sprintDistances.length > 0) {
                    GlobalFunctions.navigate(
                      context,
                      SessionPreview(
                        'Sprinting Session',
                        'Sprints',
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Session Layout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: 'PermanentMarker',
                    fontSize: DeviceInfo.deviceWidth(context) * 0.06,
                  ),
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.41,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      GlobalFunctions.navigate(
                        context,
                        AddRest(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Icon(
                      Icons.lock_clock,
                      color: Colors.greenAccent,
                      size: DeviceInfo.deviceWidth(context) * 0.3,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      GlobalFunctions.navigate(
                        context,
                        AddSprintingExercise(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.greenAccent,
                      size: DeviceInfo.deviceWidth(context) * 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.68,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  if (AppGlobals.sprintDistances.length > 0) {
                    GlobalFunctions.navigate(
                      context,
                      SessionManager(
                        mergeDurations(),
                        true,
                        true,
                      ),
                    );
                    AppGlobals.exerciseDurations = [];
                    AppGlobals.sprintDistances = [];
                  } else {
                    GlobalFunctions.showSnackBar(
                      context,
                      'You must add at least one sprint exercise',
                      textColor: Colors.black,
                      backgroundColor: Colors.redAccent,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Start Session',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.08,
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
