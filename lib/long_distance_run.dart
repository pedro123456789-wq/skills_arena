import './main.dart';
import './run_completed.dart';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Stream<int> stopWatchStream() {
  StreamController<int> streamController;
  Timer timer;
  Duration timerInterval = Duration(seconds: 1);
  int counter = 0;

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
      counter = 0;
      streamController.close();
    }
  }

  void tick(_) {
    counter++;
    streamController.add(counter);
  }

  void pauseTimer() {
    timer.cancel();
    timer = null;
  }

  void startTimer() {
    timer = Timer.periodic(timerInterval, tick);
  }

  streamController = StreamController<int>(
    onListen: startTimer,
    onCancel: stopTimer,
    onResume: startTimer,
    onPause: pauseTimer,
  );

  return streamController.stream;
}

class LongDistanceRun extends StatefulWidget {
  @override
  _LongDistanceRunState createState() => _LongDistanceRunState();
}

class _LongDistanceRunState extends State<LongDistanceRun> {
  Position previousPosition;
  bool run = true;
  double distanceCovered = 0;
  String elapsedString = '00 : 00';
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  Timer timer;
  String averagePace = '-';
  int currentKilometre = 0;

  int getSeconds(String elapsedString) {
    int minutes = int.parse(elapsedString.split(':')[0]);
    int seconds = int.parse(elapsedString.split(':')[1]);

    return (minutes * 60) + seconds;
  }

  String getTimeString(int totalSeconds) {
    String minutes = (totalSeconds ~/ 60).toString();
    String seconds = (totalSeconds - (int.parse(minutes) * 60)).toString();

    if (minutes.length < 2) {
      minutes = '0$minutes';
    }

    if (seconds.length < 2) {
      seconds = '0$seconds';
    }

    return '$minutes : $seconds';
  }

  Future<Position> getCurrentPosition() async {
    PermissionStatus permission = await Permission.location.status;

    if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
      timeLimit: Duration(
        seconds: 5,
      ),
    );

    return currentPosition;
  }

  void getAveragePace(int secondsTaken, double distance) {
    int secondsPerKm = (secondsTaken.toDouble() / distance).round();

    int minutes = secondsPerKm ~/ 60;
    int seconds = secondsPerKm - (minutes * 60);

    averagePace = '$minutes : $seconds / KM';
  }

  void trackLocations() async {
    while (run) {
      Position currentPosition = await getCurrentPosition();

      print('${currentPosition.longitude} ${currentPosition.latitude}');

      if (previousPosition != null) {
        print('${previousPosition.longitude} ${previousPosition.latitude}');

        if (this.mounted) {
          setState(
            () {
              distanceCovered += Geolocator.distanceBetween(
                previousPosition.latitude,
                previousPosition.longitude,
                currentPosition.latitude,
                currentPosition.longitude,
              );

              if (distanceCovered.round() > currentKilometre) {
                GlobalFunctions.textToSpeech(
                  'Time: $elapsedString, Distance: ${currentKilometre + 1}, Average Pace: $averagePace',
                );
                currentKilometre++;
              }
              getAveragePace(getSeconds(elapsedString), distanceCovered);
            },
          );
        }
      }

      previousPosition = currentPosition;
    }
  }

  @override
  void initState() {
    super.initState();

    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen(
      (int newTick) {
        if (this.mounted) {
          setState(
            () {
              elapsedString = getTimeString(
                newTick,
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    run = false;
    timer?.cancel();
    timerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    trackLocations();
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
                'Runner Tracker',
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
                'Distance Covered:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.23,
              left: 0,
              right: 0,
              child: Text(
                '${distanceCovered.toStringAsFixed(2)} Km',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.38,
              left: 0,
              right: 0,
              child: Text(
                'Time Taken:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.46,
              left: 0,
              right: 0,
              child: Text(
                elapsedString,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.61,
              left: 0,
              right: 0,
              child: Text(
                'Average Pace',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.69,
              left: 0,
              right: 0,
              child: Text(
                averagePace,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            (AppGlobals.isSessionPaused == false)
                ? Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.8,
                    left: 0,
                    right: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () {
                        timerSubscription.pause();
                        run = false;
                        setState(
                          () {
                            GlobalFunctions.textToSpeech('Pausing Run');
                            AppGlobals.isSessionPaused = true;
                          },
                        );
                      },
                      child: Icon(
                        Icons.motion_photos_paused_sharp,
                        color: Colors.redAccent,
                        size: DeviceInfo.deviceWidth(context) * 0.2,
                      ),
                    ),
                  )
                : Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          onPressed: () {
                            GlobalFunctions.textToSpeech('Resuming Run');
                            timerSubscription.resume();
                            run = true;
                            trackLocations();
                            setState(
                              () {
                                AppGlobals.isSessionPaused = false;
                              },
                            );
                          },
                          child: Icon(
                            Icons.not_started_outlined,
                            color: Colors.greenAccent,
                            size: DeviceInfo.deviceWidth(context) * 0.2,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          onPressed: () {
                            run = false;
                            GlobalFunctions.textToSpeech(
                              'Run Completed. Distance: ${distanceCovered.toStringAsFixed(2)} kilometres, Time: $elapsedString, Average Pace: ${averagePace.split('/')[0]} per kilometre',
                            );
                            GlobalFunctions.navigate(
                              context,
                              RunCompleted(
                                  distanceCovered, elapsedString, averagePace),
                            );

                            AppGlobals.isSessionPaused = false;
                          },
                          child: Icon(
                            Icons.stop_circle_outlined,
                            color: Colors.redAccent,
                            size: DeviceInfo.deviceWidth(context) * 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
