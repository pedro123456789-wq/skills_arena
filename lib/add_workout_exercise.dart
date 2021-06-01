import './main.dart';
import './text_input.dart';
import './create_workout.dart';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';


class AddWorkoutExercise extends StatefulWidget {
  @override
  _AddWorkoutExerciseState createState() => _AddWorkoutExerciseState();
}

class _AddWorkoutExerciseState extends State<AddWorkoutExercise> {
  final workoutExerciseNameController = TextEditingController();
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
              child: TextInput(
                workoutExerciseNameController,
                DeviceInfo.deviceWidth(context) * 0.1,
                'Exercise Name',
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.25,
              left: 0,
              right: 0,
              child: Text(
                'Duration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.4,
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
                  //get exercise name and duration
                  String exerciseName = workoutExerciseNameController.text;
                  int durationSeconds = (minutes * 60) + seconds;

                  //save exercise name
                  if (exerciseName != '') {
                    AppGlobals.workoutList.add(exerciseName);
                  } else {
                    AppGlobals.workoutList.add('Anonymous Exercise');
                  }

                  //save exercise duration
                  AppGlobals.workoutDurations.add(durationSeconds);

                  //navigate back to create_workout page
                  GlobalFunctions.navigate(
                    context,
                    CreateWorkout(),
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
