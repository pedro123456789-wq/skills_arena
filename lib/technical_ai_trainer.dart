import './main.dart';
import './swipe_back_detector.dart';
import './navigation_bar.dart';
import './technical_training.dart';

import 'package:flutter/material.dart';



class TechnicalAITrainer extends StatelessWidget {
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
                TechnicalTraining(),
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
            ),
          ],
        ),
      ),
    );
  }
}
