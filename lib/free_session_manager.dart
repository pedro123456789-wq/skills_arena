import './main.dart';
import './session_results.dart';

import 'package:flutter/material.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

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

class FreeSessionManager extends StatefulWidget {
  @override
  _FreeSessionManagerState createState() => _FreeSessionManagerState();
}

class _FreeSessionManagerState extends State<FreeSessionManager> {
  Timer timer;
  String elapsedString = '00 : 00';
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;

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

  Future<bool> checkMicrophonePermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    //increment time counter value
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen(
      (int newTick) {
        setState(
          () {
            elapsedString = getTimeString(
              newTick,
            );
          },
        );
      },
    );

    //voice indication
    GlobalFunctions.textToSpeech('The Session has started');

    //record voice periodically
    timer = Timer.periodic(
      Duration(seconds: 5),
      (Timer t) async {
        //request permission and get status
        await checkMicrophonePermission();
        String status = RecordMp3.instance.status.toString();

        //check if app is recording or not
        if (status != 'RecordStatus.RECORDING') {
          //start recording
          print('Started Recording');

          String outputPath =
              await GlobalFunctions.getTempPath('recording.mp3');
          RecordMp3.instance.start(
            outputPath,
            (type) => print(type),
          );
        } else {
          //stop recording and save file
          print('Sending Request to server');
          RecordMp3.instance.stop();

          //send file to server to perform voice recognition
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://192.168.1.142:8085/speech-to-text'),
          );

          request.files.add(
            http.MultipartFile(
              'audio',
              File(await GlobalFunctions.getTempPath('recording.mp3'))
                  .readAsBytes()
                  .asStream(),
              File(await GlobalFunctions.getTempPath('recording.mp3'))
                  .lengthSync(),
              filename: 'speech_file.mp3',
            ),
          );

          //get response from server with voice recognition results
          http.Response response =
              await http.Response.fromStream(await request.send());

          //check if any session commands have been said and execute them
          if (response.body.toLowerCase() == 'pause') {
            setState(
              () {
                timerSubscription.pause();
                GlobalFunctions.textToSpeech('Pausing Session');
                AppGlobals.isSessionPaused = true;
              },
            );
          } else if (response.body.toLowerCase() == 'stop') {
            dispose();
            AppGlobals.isSessionPaused = false;
            GlobalFunctions.textToSpeech('Ending Session');
            GlobalFunctions.navigate(
              context,
              SessionResults(
                AppGlobals.exercisesList,
                AppGlobals.exerciseRepetitions,
                getSeconds(elapsedString),
              ),
            );
            AppGlobals.exercisesList = [];
            AppGlobals.exerciseRepetitions = [];
          } else if (response.body.toLowerCase() == 'resume') {
            if (AppGlobals.isSessionPaused == true) {
              GlobalFunctions.textToSpeech('Resuming Session');
              timerSubscription.resume();
              setState(
                () {
                  AppGlobals.isSessionPaused = false;
                },
              );
            } else {
              GlobalFunctions.textToSpeech('The session is not paused');
            }
          } else if (response.body.toLowerCase().contains('completed')) {
            try {
              List<String> commandComponents =
                  response.body.toLowerCase().split(' ');
              String repetitions = commandComponents[1];
              String exercise = commandComponents
                  .sublist(2, commandComponents.length)
                  .join(' ');

              setState(() {
                AppGlobals.exerciseRepetitions.add(int.parse(repetitions));
                AppGlobals.exercisesList.add(exercise);
              });

              print('Recording Exercise...');
              print('Repetitions: $repetitions');
              print('Exercise: $exercise');

              GlobalFunctions.textToSpeech('Exercise Recorded');
            } catch (exception) {
              print(exception);
              GlobalFunctions.textToSpeech(
                  'Sorry, I did not understand your exercise name.');
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    timerSubscription.cancel();
    RecordMp3.instance.stop();
    super.dispose();
    AppGlobals.isSessionPaused = false;
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
                'Free Session',
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
                'Exercises: ${AppGlobals.exercisesList.length}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.4,
              left: 0,
              right: 0,
              child: Text(
                elapsedString,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            (AppGlobals.isSessionPaused == false)
                ? Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.75,
                    left: 0,
                    right: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () {
                        timerSubscription.pause();
                        setState(
                          () {
                            GlobalFunctions.textToSpeech('Pausing Session');
                            AppGlobals.isSessionPaused = true;
                          },
                        );
                      },
                      child: Icon(
                        Icons.motion_photos_paused_sharp,
                        color: Colors.redAccent,
                        size: DeviceInfo.deviceWidth(context) * 0.25,
                      ),
                    ),
                  )
                : Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.75,
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
                            GlobalFunctions.textToSpeech('Resuming Session');
                            timerSubscription.resume();
                            setState(
                              () {
                                AppGlobals.isSessionPaused = false;
                              },
                            );
                          },
                          child: Icon(
                            Icons.not_started_outlined,
                            color: Colors.greenAccent,
                            size: DeviceInfo.deviceWidth(context) * 0.25,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          onPressed: () {
                            dispose();
                            AppGlobals.isSessionPaused = false;
                            GlobalFunctions.textToSpeech('Ending Session');
                            GlobalFunctions.navigate(
                              context,
                              SessionResults(
                                AppGlobals.exercisesList,
                                AppGlobals.exerciseRepetitions,
                                getSeconds(elapsedString),
                              ),
                            );
                            AppGlobals.exercisesList = [];
                            AppGlobals.exerciseRepetitions = [];
                          },
                          child: Icon(
                            Icons.stop_circle_outlined,
                            color: Colors.redAccent,
                            size: DeviceInfo.deviceWidth(context) * 0.25,
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
