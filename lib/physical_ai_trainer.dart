import './main.dart';
import './swipe_back_detector.dart';
import './navigation_bar.dart';
import './physical_training.dart';

import 'package:flutter/material.dart';

//TODO: 1)Allow user to create BodyWeight session 2)Use mediapipe pose tracker or tensorflow lite to check the amount of repetitions done by the user 3)Give feedback on technique based on the user's position



class PhysicalAITrainer extends StatelessWidget {
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
              child: SwipeBackDetector(
                PhysicalTraining(),
                child: Text(
                  'AI Trainer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
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
