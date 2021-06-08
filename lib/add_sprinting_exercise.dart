import './main.dart';
import './sprinting_session.dart';
import './swipe_back_detector.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';


//TODO: Add today time trained everyday

class AddSprintingExercise extends StatefulWidget {
  @override
  _AddSprintingExerciseState createState() => _AddSprintingExerciseState();
}

class _AddSprintingExerciseState extends State<AddSprintingExercise> {
  final exerciseNameController = TextEditingController();
  int seconds;
  double currentDistance = 100;

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
                SprintingSession(),
                child: Text(
                  'Distance (meters)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.1,
              left: 0,
              right: 0,
              child: SpinBox(
                textStyle: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
                textAlign: TextAlign.center,
                incrementIcon: Icon(
                  Icons.plus_one,
                  color: Colors.greenAccent,
                  size: DeviceInfo.deviceWidth(context) * 0.05,
                ),
                decrementIcon: Icon(
                  Icons.exposure_minus_1,
                  color: Colors.redAccent,
                  size: DeviceInfo.deviceWidth(context) * 0.05,
                ),
                min: 1,
                max: 500,
                value: 100,
                onChanged: (value) {
                  currentDistance = value;
                },
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.32,
              left: 0,
              right: 0,
              child: Text(
                'Target Time',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.47,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Center(
                          child: Text(
                            'Select a Duration',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: DeviceInfo.deviceWidth(context) * 0.05,
                              fontFamily: 'PermanentMarker',
                            ),
                          ),
                        ),
                        content: Container(
                          height: DeviceInfo.deviceHeight(context) * 0.5,
                          width: DeviceInfo.deviceWidth(context) * 0.9,
                          child: Column(
                            children: [
                              Container(
                                width: DeviceInfo.deviceWidth(context) * 0.8,
                                height: DeviceInfo.deviceHeight(context) * 0.4,
                                child: CupertinoTimerPicker(
                                  mode: CupertinoTimerPickerMode.ms,
                                  onTimerDurationChanged: (value) {
                                    seconds = value.inSeconds;
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(
                                        () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: DeviceInfo.deviceWidth(context) * 0.12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Icon(
                  Icons.timer,
                  color: Colors.redAccent,
                  size: DeviceInfo.deviceWidth(context) * 0.35,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.65,
              left: 0,
              right: 0,
              child: Text(
                (seconds != null)
                    ? GlobalFunctions.timeString(
                  seconds ~/ 60,
                  seconds - ((seconds ~/ 60) * 60),
                )
                    : GlobalFunctions.timeString(
                  null,
                  null,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.05,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.8,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  AppGlobals.exerciseDurations.add(seconds);
                  AppGlobals.sprintDistances.add(currentDistance);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SprintingSession(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.greenAccent,
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
