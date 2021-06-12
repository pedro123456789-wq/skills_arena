import 'package:ultimate_translator/physical_training.dart';

import './main.dart';
import './start_session.dart';
import './swipe_back_detector.dart';
import './start_workout.dart';
import './request_handler.dart';
import './technical_training.dart';

import 'package:http/http.dart';
import 'package:flutter/material.dart';

class DeleteSessions extends StatefulWidget {
  bool isWorkout;

  DeleteSessions(this.isWorkout);

  @override
  _DeleteSessionsState createState() => _DeleteSessionsState();
}

class _DeleteSessionsState extends State<DeleteSessions> {
  Map<String, bool> checkBoxValues = {};

  int getCheckedBoxes() {
    int checkedBoxes = 0;

    for (String key in checkBoxValues.keys) {
      if (checkBoxValues[key]) {
        checkedBoxes++;
      }
    }

    return checkedBoxes;
  }

  Future<List<Widget>> createSessionCheckBoxes() async {
    List<Widget> sessionRows = [];

    Response sessionRequest = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1],
      },
      'http://192.168.1.142:8090/get-sessions',
    );

    List<String> sessionList = sessionRequest.body.split('\n');

    String sessionCode;
    (widget.isWorkout) ? sessionCode = 't2' : sessionCode = 't1';

    for (String session in sessionList) {
      if (session.length > 0) {
        String currentSessionCode = session.split('-')[0];
        String currentSessionName = session.split('-')[1].split(':')[0];

        if (sessionCode == currentSessionCode) {
          if (!checkBoxValues.keys.contains(currentSessionName)) {
            checkBoxValues[currentSessionName] = false;
          }

          sessionRows.add(
            Container(
              alignment: Alignment.center,
              child: CheckboxListTile(
                checkColor: Colors.redAccent,
                activeColor: Colors.greenAccent,
                tileColor: Colors.black,
                value: checkBoxValues[currentSessionName],
                onChanged: (bool value) {
                  setState(
                        () {
                      checkBoxValues[currentSessionName] = value;
                    },
                  );
                },
                title: Text(
                  currentSessionName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return sessionRows;
  }

  void deleteSelectedSessions() async {
    String sessionType;
    (widget.isWorkout) ? sessionType = 't2' : sessionType = 't1';

    for (String key in checkBoxValues.keys) {
      if (checkBoxValues[key]) {
        Response deleteRequest = await RequestHandler.sendPost(
          {
            'username': (await GlobalFunctions.getCredentials())[0],
            'password': (await GlobalFunctions.getCredentials())[1],
            'session_type': sessionType,
            'session_name': key,
          },
          'http://192.168.1.142:8090/delete-session',
        );
      }
    }

    Response sessionNumber = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1],
        'session_type': sessionType,
      },
      'http://192.168.1.142:8090/get-session-number',
    );

    if (int.parse(sessionNumber.body) > 0) {
      setState(() {});
    } else {
      Widget destination;

      if (widget.isWorkout) {
        destination = PhysicalTraining();
      } else {
        destination = TechnicalTraining();
      }

      GlobalFunctions.navigate(
        context,
        destination,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    createSessionCheckBoxes();
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
                (widget.isWorkout) ? StartWorkout() : StartSession(),
                child: Text(
                  (widget.isWorkout) ? 'Delete Workouts' : 'Delete Sessions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: createSessionCheckBoxes(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.hasData) {
                  return Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.15,
                    left: 0,
                    right: 0,
                    bottom: DeviceInfo.deviceHeight(context) * 0.15,
                    child: SingleChildScrollView(
                      child: Column(
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
            if (getCheckedBoxes() > 0)
              Positioned(
                top: DeviceInfo.deviceHeight(context) * 0.8,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: () {
                    deleteSelectedSessions();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
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
