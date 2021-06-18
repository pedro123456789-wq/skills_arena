import './main.dart';
import './navigation_bar.dart';
import './image_button.dart';
import './create_session.dart';
import './start_session.dart';
import './free_session.dart';
import './skill_bank.dart';
import './technical_ai_trainer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TechnicalTraining extends StatelessWidget {
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
                'Technical \n Training',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.2,
              left: 0,
              right: 0,
              bottom: DeviceInfo.deviceHeight(context) * 0.03,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: DeviceInfo.deviceWidth(context),
                      color: Colors.black,
                      child: ImageButton(
                        () {
                          GlobalFunctions.navigate(
                            context,
                            TechnicalAITrainer(),
                          );
                        },
                        'assets/ai_trainer.png',
                        'AI Trainer',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.05,
                      ),
                    ),
                    Container(
                      width: DeviceInfo.deviceWidth(context),
                      padding: EdgeInsets.only(
                        top: DeviceInfo.deviceHeight(context) * 0.05,
                      ),
                      child: ImageButton(
                        () {
                          GlobalFunctions.navigate(
                            context,
                            FreeSession(),
                          );
                        },
                        'assets/free_session.png',
                        'Free Session',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.05,
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
                            CreateSession(),
                          );
                        },
                        'assets/custom_workout.png',
                        'Create Session',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.05,
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
                            StartSession(),
                          );
                        },
                        'assets/start_session.png',
                        'Start Session',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.05,
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
                            SkillBank(),
                          );
                        },
                        'assets/challenges.png',
                        'Skill Bank',
                        DeviceInfo.deviceHeight(context) * 0.3,
                        DeviceInfo.deviceWidth(context) * 0.8,
                        DeviceInfo.deviceWidth(context) * 0.05,
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
