import './main.dart';
import './sprinting_session.dart';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';


class AddSprintingExercise extends StatefulWidget {
  @override
  _AddSprintingExerciseState createState() => _AddSprintingExerciseState();
}

class _AddSprintingExerciseState extends State<AddSprintingExercise> {
  final exerciseNameController = TextEditingController();
  int minutes;
  int seconds;
  double currentDistance = 100;

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
                'Distance (meters)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.1,
              left: 0,
              right: 0,
              child: SpinBox(
                textStyle: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
                textAlign: TextAlign.center,
                incrementIcon: Icon(
                  Icons.plus_one,
                  color: Colors.greenAccent,
                  size: DeviceInfo.deviceWidth(context) * 0.05,
                ),
                decrementIcon: Icon(
                  Icons.exposure_minus_1,
                  color: Colors.redAccent,
                  size: DeviceInfo.deviceWidth(context) * 0.05,
                ),
                min: 1,
                max: 500,
                value: 100,
                onChanged: (value) {
                  currentDistance = value;
                },
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.32,
              left: 0,
              right: 0,
              child: Text(
                'Target Time',
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
                  Picker(
                    backgroundColor: Colors.white,
                    adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                      const NumberPickerColumn(
                        begin: 0,
                        end: 999,
                        suffix: Text(' minutes'),
                        jump: 1,
                      ),
                      const NumberPickerColumn(
                        begin: 0,
                        end: 59,
                        suffix: Text(' seconds'),
                        jump: 1,
                      ),
                    ]),
                    delimiter: <PickerDelimiter>[
                      PickerDelimiter(
                        child: Container(
                          width: DeviceInfo.deviceWidth(context) * 0.05,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                            size: DeviceInfo.deviceWidth(context) * 0.15,
                          ),
                        ),
                      ),
                    ],
                    hideHeader: true,
                    confirmText: 'OK',
                    cancelTextStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: DeviceInfo.deviceWidth(context) * 0.05,
                    ),
                    confirmTextStyle: TextStyle(
                        inherit: false,
                        color: Colors.greenAccent,
                        fontSize: DeviceInfo.deviceWidth(context) * 0.05),
                    title: const Text(
                      'Select duration',
                      style: TextStyle(
                        color: Colors.greenAccent,
                      ),
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.greenAccent,
                    ),
                    onConfirm: (Picker picker, List<int> value) {
                      setState(
                        () {
                          minutes = picker.getSelectedValues()[0];
                          seconds = picker.getSelectedValues()[1];
                        },
                      );
                    },
                  ).showDialog(context);
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
              top: DeviceInfo.deviceHeight(context) * 0.65,
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
                  AppGlobals.sprintDistances.add(currentDistance);

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
