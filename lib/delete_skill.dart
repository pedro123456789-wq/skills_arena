import './main.dart';
import './navigation_bar.dart';

import 'package:flutter/material.dart';


class DeleteSkill extends StatefulWidget {
  @override
  _DeleteSkillState createState() => _DeleteSkillState();
}


class _DeleteSkillState extends State<DeleteSkill> {
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
                'Delete Skill',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
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
