import './main.dart';
import './text_input.dart';
import './record_video.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//TODO: Save video and skill name to database


class AddNewSkill extends StatefulWidget {
  @override
  _AddNewSkillState createState() => _AddNewSkillState();
}

class _AddNewSkillState extends State<AddNewSkill> {
  TextEditingController skillNameController = new TextEditingController();

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
              child: Text(
                'New Skill',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.2,
              left: 0,
              right: 0,
              child: TextInput(
                skillNameController,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Skill Name',
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.4,
              left: 0,
              right: 0,
              child: Text(
                'Add video of skill',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.5,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      DeviceInfo.deviceWidth(context) * 0.05,
                      0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        GlobalFunctions.navigate(
                          context,
                          RecordVideo(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Icon(
                        Icons.camera_enhance_sharp,
                        color: Colors.greenAccent,
                        size: DeviceInfo.deviceWidth(context) * 0.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      DeviceInfo.deviceWidth(context) * 0.05,
                      0,
                      0,
                      0,
                    ),
                    child: ElevatedButton(
                      onPressed: () => print(''),
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Icon(
                        Icons.image,
                        color: Colors.greenAccent,
                        size: DeviceInfo.deviceWidth(context) * 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.8,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () => print(''),
                style: ElevatedButton.styleFrom(primary: Colors.black),
                child: Text(
                  'Save Skill',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.08,
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
