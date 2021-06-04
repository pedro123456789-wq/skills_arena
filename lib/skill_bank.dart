import './main.dart';
import './navigation_bar.dart';
import './add_new_skill.dart';
import './request_handler.dart';
import './display_skill.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SkillBank extends StatelessWidget {
  Future<List<Widget>> getSkills(BuildContext context) async {
    List<Widget> skillRows = [];

    Response skills = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1],
      },
      'http://192.168.1.142:8090/get-skill-names',
    );

    List<String> skillNames = skills.body.split(',');

    for (String skillName in skillNames) {
      skillRows.add(
        Container(
          padding: EdgeInsets.fromLTRB(
            0,
            DeviceInfo.deviceHeight(context) * 0.03,
            0,
            0,
          ),
          child: ElevatedButton(
            onPressed: () {
              GlobalFunctions.navigate(
                context,
                DisplaySkill(skillName),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            child: Text(
              skillName,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                fontFamily: 'PermanentMarker',
              ),
            ),
          ),
        ),
      );
    }

    return skillRows;
  }

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
            FutureBuilder(
              future: getSkills(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.15,
                    left: 0,
                    right: 0,
                    bottom: DeviceInfo.deviceHeight(context) * 0.1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: snapshot.data,
                      ),
                    ),
                  );
                } else {
                  return Stack(
                    children: [
                      Positioned(
                        top: DeviceInfo.deviceHeight(context) * 0.45,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      Positioned(
                        top: DeviceInfo.deviceHeight(context) * 0.5,
                        left: 0,
                        right: 0,
                        child: Text(
                          'Loading Data...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                            fontFamily: 'PermanentMarker',
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
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
            ),
          ],
        ),
      ),
    );
  }
}
