import './main.dart';
import './navigation_bar.dart';
import './image_button.dart';
import './create_workout.dart';
import './start_workout.dart';
import './sprinting_session.dart';
import './long_distance_run_start.dart';
import './physical_ai_trainer.dart';

import 'package:flutter/material.dart';

class PhysicalTraining extends StatelessWidget {
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
              child: Text(
                'Physical \n Training',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: DeviceInfo.deviceHeight(context) * 0.2,
              bottom: DeviceInfo.deviceHeight(context) * 0.03,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: ImageButton(
                        () {
                          GlobalFunctions.navigate(
                            context,
                            PhysicalAITrainer(),
                          );
                        },
                        'assets/ai_gym_trainer.png',
                        'AI Trainer',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.045,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: DeviceInfo.deviceHeight(context) * 0.05,
                      ),
                      child: ImageButton(
                        () {
                          GlobalFunctions.navigate(
                            context,
                            LongDistanceRunStart(),
                          );
                        },
                        'assets/long_distance_run.png',
                        'Long Distance Run',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.045,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: DeviceInfo.deviceHeight(context) * 0.05,
                      ),
                      child: ImageButton(
                        () {
                          GlobalFunctions.navigate(
                            context,
                            CreateWorkout(),
                          );
                        },
                        'assets/create_workout.png',
                        'Create Workout Run',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.045,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: DeviceInfo.deviceHeight(context) * 0.05,
                      ),
                      child: ImageButton(
                        () {
                          GlobalFunctions.navigate(
                            context,
                            StartWorkout(),
                          );
                        },
                        'assets/start_workout.png',
                        'Start Workout',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.045,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: DeviceInfo.deviceHeight(context) * 0.05,
                      ),
                      child: ImageButton(
                        () {
                          GlobalFunctions.navigate(
                            context,
                            SprintingSession(),
                          );
                        },
                        'assets/sprinting_session.png',
                        'Sprinting Session',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.045,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
