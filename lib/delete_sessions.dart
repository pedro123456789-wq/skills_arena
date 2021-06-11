import './main.dart';
import './start_session.dart';
import './swipe_back_detector.dart';
import './start_workout.dart';

import 'package:flutter/material.dart';

class DeleteSessions extends StatefulWidget {
  bool isWorkout;

  DeleteSessions(this.isWorkout);

  @override
  _DeleteSessionsState createState() => _DeleteSessionsState();
}

class _DeleteSessionsState extends State<DeleteSessions> {
  List<Widget> createSessionCheckBoxes() {
    return [Text('')];
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
            )
          ],
        ),
      ),
    );
  }
}
