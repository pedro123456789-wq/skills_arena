import './main.dart';
import './text_input.dart';
import './create_session.dart';
import './swipe_back_detector.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddExercise extends StatefulWidget {
  @override
  _AddExerciseState createState() => _AddExerciseState();
}

//TODO: add error message to force user to enter exercise name and duration
//TODO: add option to delete exercises and see session layout
//TODO: Make gesture detector work everywhere on pages

class _AddExerciseState extends State<AddExercise> {
  final exerciseNameController = TextEditingController();
  int seconds;

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
                CreateSession(),
                child: TextInput(
                  exerciseNameController,
                  DeviceInfo.deviceWidth(context) * 0.1,
                  'Exercise Name',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.25,
              left: 0,
              right: 0,
              child: Text(
                'Duration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.4,
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
                        (seconds ~/ 60),
                        seconds - ((seconds ~/ 60) * 60),
                      )
                    : GlobalFunctions.timeString(null, null),
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
                  String exerciseName = exerciseNameController.text;

                  if (exerciseName != null) {
                    AppGlobals.exercisesList.add(exerciseName);
                  } else {
                    AppGlobals.exercisesList.add('Anonymous Exercise');
                  }

                  AppGlobals.exerciseDurations.add(seconds);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateSession(),
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
