import './main.dart';
import './navigation_bar.dart';
import './text_input.dart';
import './add_exercise.dart';
import './landing_page.dart';
import './request_handler.dart';
import './swipe_back_detector.dart';
import './technical_training.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

//t1- is the code for technical session in database
//TODO: add clear session option

class CreateSession extends StatefulWidget {
  @override
  _CreateSessionState createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  String durationString;
  int exercises = AppGlobals.exercisesList.length;
  final sessionNameController = TextEditingController();

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
                TechnicalTraining(),
                child: TextInput(
                  sessionNameController,
                  DeviceInfo.deviceWidth(context) * 0.1,
                  AppGlobals.sessionName,
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
                onPressed: () => print(''),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExercise(),
                    ),
                  );
                  if (sessionNameController.text != '') {
                    AppGlobals.sessionName = sessionNameController.text;
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
                  //get output string
                  String outputString = '';
                  outputString += 't1-${AppGlobals.sessionName}:';

                  for (int i = 0; i < AppGlobals.exercisesList.length; i++) {
                    String exercise = AppGlobals.exercisesList[i];
                    int duration = AppGlobals.exerciseDurations[i];
                    outputString += '$exercise, $duration;';
                  }

                  outputString =
                      outputString.substring(0, outputString.length - 1);
                  outputString += '\n';

                  //write to database
                  Response response = await RequestHandler.sendPost(
                    {
                      'username': (await GlobalFunctions.getCredentials())[0],
                      'password': (await GlobalFunctions.getCredentials())[1],
                    },
                    'http://192.168.1.142:8090/create-session',
                    body: outputString,
                  );

                  //TODO: Add error checking

                  //reset global variables
                  AppGlobals.exercisesList = [];
                  AppGlobals.exerciseDurations = [];
                  AppGlobals.sessionName = 'Session Name';

                  //navigate to main menu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandingPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Save Session',
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
