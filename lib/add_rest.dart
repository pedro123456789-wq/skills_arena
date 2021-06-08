import './main.dart';
import './sprinting_session.dart';
import './swipe_back_detector.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class AddRest extends StatefulWidget {
  @override
  _AddRestState createState() => _AddRestState();
}

class _AddRestState extends State<AddRest> {
  int minutes;
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
                SprintingSession(),
                child: Text(
                  'Rest Period',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.32,
              left: 0,
              right: 0,
              child: Text(
                'Rest Duration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.47,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
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
              top: DeviceInfo.deviceHeight(context) * 0.7,
              left: 0,
              right: 0,
              child: Text(
                GlobalFunctions.timeString(minutes, seconds),
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
                  int durationSeconds = (minutes * 60) + seconds;
                  AppGlobals.exerciseDurations.add(durationSeconds);
                  AppGlobals.sprintDistances.add(-1);

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
