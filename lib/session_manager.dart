import './main.dart';
import 'landing_page.dart';
import './session_finished.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';


class SessionManager extends StatefulWidget {
  final List exercises;
  final bool isWorkout;
  final bool isSprint;
  final String sessionName;
  String sessionType;
  int exercisesIndex = -1;
  String exerciseName = 'Starting In: ';

  SessionManager(
    this.exercises,
    this.isWorkout,
    this.isSprint, {
    this.sessionName,
  });

  @override
  _SessionManagerState createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  CountDownController _controller = CountDownController();

  String getSessionType(bool isWorkout) {
    if (isWorkout == true) {
      return 'Workout';
    } else {
      return 'Session';
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.sessionType = getSessionType(widget.isWorkout);
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
                widget.exerciseName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.25,
              left: 0,
              right: 0,
              child: CircularCountDownTimer(
                duration: 3,
                initialDuration: 0,
                controller: _controller,
                width: DeviceInfo.deviceWidth(context) * 0.4,
                height: DeviceInfo.deviceHeight(context) * 0.4,
                ringColor: Colors.black,
                fillColor: Colors.greenAccent,
                fillGradient: null,
                backgroundColor: Colors.black,
                backgroundGradient: null,
                strokeWidth: 20.0,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PermanentMarker',
                ),
                textFormat: CountdownTextFormat.S,
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                autoStart: true,
                onStart: () async {
                  String text = '';

                  if (widget.exercisesIndex == -1) {
                    if (widget.sessionName == null) {
                      text = 'Starting ${widget.sessionType}';
                    }else{
                      text = 'Starting ${widget.sessionName}';
                    }
                  } else {
                    text =
                        '${widget.exercises[widget.exercisesIndex].split(',')[0]} starting now.';
                  }

                  await GlobalFunctions.textToSpeech(text);
                },
                onComplete: () {
                  setState(
                    () {
                      if (widget.exercisesIndex < widget.exercises.length - 1) {
                        widget.exercisesIndex++;
                        _controller.restart(
                          duration: int.parse(widget
                              .exercises[widget.exercisesIndex]
                              .split(',')[1]),
                        );
                        widget.exerciseName = widget
                            .exercises[widget.exercisesIndex]
                            .split(',')[0];
                      } else {
                        GlobalFunctions.navigate(
                          context,
                          SessionFinished(
                            widget.sessionType,
                            widget.exercises,
                            widget.isSprint,
                          ),
                        );
                        GlobalFunctions.textToSpeech(
                          '${widget.sessionType} Completed!',
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        if (AppGlobals.isSessionPaused) {
                          setState(() {
                            GlobalFunctions.textToSpeech(
                                'Resuming ${widget.sessionType}');
                            _controller.resume();
                            AppGlobals.isSessionPaused = false;
                          });
                        } else {
                          setState(() {
                            GlobalFunctions.textToSpeech(
                                'Pausing ${widget.sessionType}');
                            _controller.pause();
                            AppGlobals.isSessionPaused = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Icon(
                        AppGlobals.isSessionPaused == false
                            ? Icons.motion_photos_paused_sharp
                            : Icons.not_started_outlined,
                        color: AppGlobals.isSessionPaused == false
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        size: DeviceInfo.deviceWidth(context) * 0.2,
                      ),
                    ),
                  ),
                  if (AppGlobals.isSessionPaused)
                    ElevatedButton(
                      onPressed: () {
                        GlobalFunctions.textToSpeech(
                            'Ending ${widget.sessionType}');
                        GlobalFunctions.navigate(
                          context,
                          LandingPage(),
                        );
                        AppGlobals.isSessionPaused = false;
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black),
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
