import './main.dart';
import './navigation_bar.dart';
import './text_input.dart';
import './landing_page.dart';
import './add_workout_exercise.dart';
import './request_handler.dart';
import './swipe_back_detector.dart';
import './physical_training.dart';
import './session_preview.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

//t2 is the code for workout exercises in database

class CreateWorkout extends StatefulWidget {
  @override
  _CreateWorkoutState createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  String durationString;
  int exercises = AppGlobals.workoutList.length;
  final workoutNameController = TextEditingController();

  String getTotalDuration() {
    if (AppGlobals.workoutDurations.length > 0) {
      int totalSeconds = AppGlobals.workoutDurations.reduce(
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
    durationString = getTotalDuration();

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
                  AppGlobals.workoutList = [];
                  AppGlobals.workoutDurations = [];
                  AppGlobals.workoutName = 'Workout Name';
                },
                child: TextInput(
                  workoutNameController,
                  DeviceInfo.deviceWidth(context) * 0.1,
                  AppGlobals.workoutName,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.14,
              left: 0,
              right: 0,
              child: Text(
                'Duration: \n $durationString',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
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
                  if (AppGlobals.workoutList.length > 0) {
                    GlobalFunctions.navigate(
                      context,
                      SessionPreview(
                        AppGlobals.workoutName,
                        isWorkout: true,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Exercises: $exercises',
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
              child: ElevatedButton(
                onPressed: () {
                  GlobalFunctions.navigate(
                    context,
                    AddWorkoutExercise(),
                  );
                  if (workoutNameController.text != '') {
                    AppGlobals.workoutName = workoutNameController.text;
                  }
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
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.68,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  if (AppGlobals.workoutList.length > 0 &&
                      AppGlobals.workoutName.length > 0 &&
                      AppGlobals.workoutName != 'Workout Name') {
                    //get output string
                    String outputString = '';
                    outputString += 't2-${AppGlobals.workoutName}:';

                    for (int i = 0; i < AppGlobals.workoutList.length; i++) {
                      String exercise = AppGlobals.workoutList[i];
                      int duration = AppGlobals.workoutDurations[i];
                      outputString += '$exercise, $duration;';
                    }
                    outputString =
                        outputString.substring(0, outputString.length - 1);

                    //write it to file
                    Response response = await RequestHandler.sendPost(
                      {
                        'username': (await GlobalFunctions.getCredentials())[0],
                        'password': (await GlobalFunctions.getCredentials())[1],
                      },
                      'http://192.168.1.142:8090/create-session',
                      body: outputString,
                    );

                    //reset global variables
                    AppGlobals.workoutList = [];
                    AppGlobals.workoutDurations = [];
                    AppGlobals.workoutName = 'Session Name';

                    //navigate to main menu
                    GlobalFunctions.navigate(context, LandingPage());
                  } else {
                    GlobalFunctions.showSnackBar(
                      context,
                      'You must enter a session name and at least one exercise',
                      textColor: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Save Workout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.07,
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
