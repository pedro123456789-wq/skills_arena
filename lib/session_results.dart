import './main.dart';
import './landing_page.dart';
import './request_handler.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SessionResults extends StatelessWidget {
  final List<String> exerciseNames;
  final List<int> exerciseRepetitions;
  final int sessionDuration;

  SessionResults(
    this.exerciseNames,
    this.exerciseRepetitions,
    this.sessionDuration,
  );

  List<Widget> createColumn(BuildContext context) {
    List<Widget> columnWidgets = [];

    for (int i = 0; i < exerciseNames.length; i++) {
      columnWidgets.add(
        Container(
          padding: EdgeInsets.fromLTRB(
            0,
            DeviceInfo.deviceHeight(context) * 0.05,
            0,
            0,
          ),
          child: Text(
            '${exerciseRepetitions[i]} ${exerciseNames[i]}',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: DeviceInfo.deviceWidth(context) * 0.07,
              fontFamily: 'PermanentMarker',
            ),
          ),
        ),
      );
    }

    return columnWidgets;
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
                'Session Results',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.15,
              left: 0,
              right: 0,
              bottom: DeviceInfo.deviceHeight(context) * 0.15,
              child: SingleChildScrollView(
                child: Column(
                  children: createColumn(context),
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.85,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  String outputString =
                      '\n${(sessionDuration / 60).toDouble()}-${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}-Session';

                  Response response = await RequestHandler.sendPost(
                    {
                      'username': (await GlobalFunctions.getCredentials())[0],
                      'password': (await GlobalFunctions.getCredentials())[1],
                    },
                    'http://192.168.1.142:8090/add-workout-data',
                    body: outputString,
                  );

                  GlobalFunctions.navigate(
                    context,
                    LandingPage(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'PermanentMarker',
                    fontSize: DeviceInfo.deviceWidth(context) * 0.08,
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
