import './main.dart';
import './landing_page.dart';
import './request_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class SessionFinished extends StatelessWidget {
  final String sessionType;
  final List<String> exercises;
  final bool isSprint;

  SessionFinished(this.sessionType, this.exercises, this.isSprint);

  void addDuration() async {
    int totalDuration = 0;

    for (int i = 0; i < exercises.length; i++) {
      totalDuration += int.parse(exercises[i].split(',')[1]);
    }

    String outputString =
        '\n${(totalDuration / 60).toDouble()}-${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}-$sessionType';

    Response response = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1],
      },
      'http://192.168.1.142:8090/add-workout-data',
      body: outputString,
    );
  }

  void addDistanceRan() async {
    double distance = 0;

    for (String exercise in exercises) {
      String exerciseComponent = exercise.split(',')[0];

      if (exercises.contains('rest') == false) {
        distance += int.parse(
          exerciseComponent
              .split(' ')[0]
              .substring(0, exerciseComponent.split(' ')[0].length - 1),
        );
      }
    }

    distance /= 1000;

    Response response = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1],
      },
      'http://192.168.1.142:8090/add-distance-ran',
      body:
          '\n${distance.toStringAsFixed(2)}-${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}-Sprint',
    );
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
              child: Text(
                '$sessionType \n Completed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.35,
              left: 0,
              right: 0,
              child: Text(
                'Keep Going \n Do another one!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.7,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  addDuration();

                  if (isSprint) {
                    addDistanceRan();
                  }

                  GlobalFunctions.navigate(context, LandingPage());
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.sports_soccer,
                      color: Colors.greenAccent,
                      size: DeviceInfo.deviceWidth(context) * 0.25,
                    ),
                    Text(
                      'Return to Menu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                        fontFamily: 'PermanentMarker',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
