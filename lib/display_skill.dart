import './main.dart';
import './request_handler.dart';

import 'package:flutter/material.dart';

class DisplaySkill extends StatelessWidget {
  final String skillName;

  DisplaySkill(this.skillName);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.01,
              left: 0,
              right: 0,
              child: Text(
                skillName,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
