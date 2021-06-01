import './main.dart';
import './navigation_bar.dart';
import './image_button.dart';
import './technical_training.dart';
import './physical_training.dart';

import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
                'Skills Arena',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.12,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.08,
              left: 0,
              right: 0,
              child: Text(
                'Elite Football Training',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.18,
              left: 0,
              right: 0,
              child: ImageButton(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TechnicalTraining(),
                    ),
                  );
                },
                'assets/technical_training.png',
                'Technical Training',
                DeviceInfo.deviceHeight(context) * 0.25,
                DeviceInfo.deviceWidth(context) * 0.8,
                DeviceInfo.deviceWidth(context) * 0.05,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.48,
              left: 0,
              right: 0,
              child: ImageButton(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhysicalTraining(),
                    ),
                  );
                },
                'assets/physical_training.png',
                'Physical Training',
                DeviceInfo.deviceHeight(context) * 0.25,
                DeviceInfo.deviceWidth(context) * 0.8,
                DeviceInfo.deviceWidth(context) * 0.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
