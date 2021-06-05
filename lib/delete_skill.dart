import './main.dart';
import './navigation_bar.dart';
import './request_handler.dart';
import './skill_bank.dart';

import 'package:http/http.dart';
import 'package:flutter/material.dart';



class DeleteSkill extends StatefulWidget {
  @override
  _DeleteSkillState createState() => _DeleteSkillState();
}


class _DeleteSkillState extends State<DeleteSkill> {
  Map<String, bool> checkboxValues = {};

  Future<List<Widget>> buildColumn() async {
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
      if (!checkboxValues.keys.contains(skillName)) {
        checkboxValues[skillName] = false;
      }

      skillRows.add(
        Container(
          alignment: Alignment.center,
          child: CheckboxListTile(
            checkColor: Colors.redAccent,
            activeColor: Colors.greenAccent,
            tileColor: Colors.black,
            value: checkboxValues[skillName],
            onChanged: (bool value) {
              setState(
                () {
                  checkboxValues[skillName] = value;
                },
              );
            },
            title: Text(
              skillName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.greenAccent,
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
    buildColumn();
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
                'Delete Skills',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.15,
              left: 0,
              right: 0,
              bottom: DeviceInfo.deviceHeight(context) * 0.15,
              child: FutureBuilder(
                future: buildColumn(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: snapshot.data,
                      ),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        DeviceInfo.deviceHeight(context) * 0.3,
                        0,
                        0,
                      ),
                      alignment: Alignment.center,
                      child: LinearProgressIndicator(
                        color: Colors.grey,
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.7,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  for (String skill in checkboxValues.keys) {
                    if (checkboxValues[skill]) {
                      Response confirmation = await RequestHandler.sendPost({
                        'username': (await GlobalFunctions.getCredentials())[0],
                        'password': (await GlobalFunctions.getCredentials())[1],
                        'skill_name': skill,
                      }, 'http://192.168.1.142:8090/delete-skill');
                    }
                  }

                  GlobalFunctions.navigate(
                    context,
                    SkillBank(),
                  );
                },
                style: ElevatedButton.styleFrom(primary: Colors.black),
                child: Icon(
                  Icons.delete,
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
