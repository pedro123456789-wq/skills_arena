import './main.dart';
import './navigation_bar.dart';
import './add_new_skill.dart';

import 'package:flutter/material.dart';

class SkillBank extends StatelessWidget {
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
                'Skill Bank',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.7,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  GlobalFunctions.navigate(
                    context,
                    AddNewSkill(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.redAccent,
                  size: DeviceInfo.deviceWidth(context) * 0.15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
