import './main.dart';
import './navigation_bar.dart';
import './session_layout.dart';
import './request_handler.dart';
import './swipe_back_detector.dart';
import './physical_training.dart';
import './delete_sessions.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';


class StartWorkout extends StatefulWidget {
  @override
  _StartWorkoutState createState() => _StartWorkoutState();
}

class _StartWorkoutState extends State<StartWorkout> {
  Future futurePointer;
  bool isValid = false;

  Future<List<Widget>> getSessionButtons(BuildContext context) async {
    List<Widget> sessions = [];

    Response response = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1],
      },
      'http://192.168.1.142:8090/get-sessions',
    );

    List<String> sessionData = response.body.split('\n');

    for (String session in sessionData) {
      if (session.contains('t2-')) {
        sessions.add(
          Container(
            padding: EdgeInsets.fromLTRB(
              0,
              DeviceInfo.deviceHeight(context) * 0.02,
              0,
              0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () async {
                String sessionName = session.split(':')[0].split('-')[1];
                List<String> exercises = session.split(':')[1].split(';');

                GlobalFunctions.navigate(
                  context,
                  SessionLayout(
                    sessionName: sessionName,
                    exercises: exercises,
                    isWorkout: true,
                  ),
                );
              },
              child: Text(
                session.split(':')[0].split('-')[1],
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
          ),
        );
      }
    }

    if (sessions.length > 0) {
      setState(
            () {
          isValid = true;
        },
      );

      return sessions;
    } else {
      return [
        Container(
          padding: EdgeInsets.fromLTRB(
            0,
            DeviceInfo.deviceHeight(context) * 0.25,
            0,
            0,
          ),
          child: Text(
            'You have not saved any workouts yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: DeviceInfo.deviceWidth(context) * 0.07,
              fontFamily: 'PermanentMarker',
            ),
          ),
        ),
      ];
    }
  }

  @override
  void initState() {
    futurePointer = getSessionButtons(context);
    super.initState();
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
                child: Text(
                  'Choose Workout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: futurePointer,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return new Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.15,
                    left: 0,
                    right: 0,
                    bottom: DeviceInfo.deviceHeight(context) * 0.035,
                    child: new SingleChildScrollView(
                      child: new Column(
                        children: snapshot.data,
                      ),
                    ),
                  );
                } else {
                  return Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.45,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                  );
                }
              },
            ),
            if (isValid)
              Positioned(
                top: DeviceInfo.deviceHeight(context) * 0.7,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: () {
                    GlobalFunctions.navigate(
                      context,
                      DeleteSessions(true),
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: DeviceInfo.deviceWidth(context) * 0.15,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
