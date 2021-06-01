import './main.dart';
import './landing_page.dart';
import './request_handler.dart';

import 'package:http/http.dart';
import 'package:flutter/material.dart';

class RunCompleted extends StatelessWidget {
  final double distance;
  final String time;
  final String averagePace;

  RunCompleted(
    this.distance,
    this.time,
    this.averagePace,
  );

  int getSeconds(String elapsedString) {
    int minutes = int.parse(elapsedString.split(':')[0]);
    int seconds = int.parse(elapsedString.split(':')[1]);

    return (minutes * 60) + seconds;
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
                'Run Complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.15,
              left: 0,
              right: 0,
              child: Text(
                'Distance Covered: \n ${distance.toStringAsFixed(2)} km \n\n Time Taken: $time \n\n Average Pace: \n $averagePace',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.085,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.7,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  GlobalFunctions.navigate(context, LandingPage());

                  Response recordDistance = await RequestHandler.sendPost(
                    {
                      'username': (await GlobalFunctions.getCredentials())[0],
                      'password': (await GlobalFunctions.getCredentials())[1],
                    },
                    'http://192.168.1.142:8090/add-distance-ran',
                    body:
                        '\n${distance.toStringAsFixed(2)}-${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}-LongDistance',
                  );

                  Response recordTime = await RequestHandler.sendPost(
                    {
                      'username': (await GlobalFunctions.getCredentials())[0],
                      'password': (await GlobalFunctions.getCredentials())[1],
                    },
                    'http://192.168.1.142:8090/add-workout-data',
                    body: '\n${(getSeconds(time) / 60).toDouble()}-${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}-Workout',
                  );
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
