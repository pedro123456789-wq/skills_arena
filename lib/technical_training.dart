import './main.dart';
import './navigation_bar.dart';
import './image_button.dart';
import './create_session.dart';
import './start_session.dart';
import './free_session.dart';
import './skill_bank.dart';

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
              child: ImageButton(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateSession(),
                    ),
                  );
                },
                'assets/custom_workout.png',
                'Create Session',
                DeviceInfo.deviceHeight(context) * 0.2,
                DeviceInfo.deviceWidth(context) * 0.45,
                DeviceInfo.deviceWidth(context) * 0.05,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.2,
              right: 0,
              child: ImageButton(
                () {
                  GlobalFunctions.navigate(
                    context,
                    FreeSession(),
                  );
                },
                'assets/free_session.png',
                'Free Session',
                DeviceInfo.deviceHeight(context) * 0.2,
                DeviceInfo.deviceWidth(context) * 0.45,
                DeviceInfo.deviceWidth(context) * 0.05,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.5,
              left: 0,
              child: ImageButton(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartSession(),
                    ),
                  );
                },
                'assets/start_session.png',
                'Start Session',
                DeviceInfo.deviceHeight(context) * 0.2,
                DeviceInfo.deviceWidth(context) * 0.45,
                DeviceInfo.deviceWidth(context) * 0.05,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.5,
              right: 0,
              child: ImageButton(
                () {
                  GlobalFunctions.navigate(
                    context,
                    SkillBank(),
                  );
                },
                'assets/challenges.png',
                'Skill Bank',
                DeviceInfo.deviceHeight(context) * 0.2,
                DeviceInfo.deviceWidth(context) * 0.45,
                DeviceInfo.deviceWidth(context) * 0.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
