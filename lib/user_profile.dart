import 'package:skills_arena/change_password.dart';

import './main.dart';
import './navigation_bar.dart';
import './custom_icon_button.dart';
import './login_page.dart';
import './request_handler.dart';

import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String userName;

  UserProfile(
    this.userName,
  );

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
                'Account settings \n $userName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.3,
              left: 0,
              right: 0,
              child: CustomIconButton(
                text: 'Logout',
                callBack: () async {
                  File loginFile =
                      File(await GlobalFunctions.getTempPath('login_file.txt'));
                  loginFile.writeAsString('');
                  GlobalFunctions.navigate(
                    context,
                    LoginPage(),
                  );
                },
                textColor: Colors.grey,
                iconColor: Colors.grey,
                icon: Icons.logout,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.45,
              left: 0,
              right: 0,
              child: CustomIconButton(
                text: 'Delete Account',
                textColor: Colors.redAccent,
                callBack: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white10,
                        title: Center(
                          child: Text(
                            'Are you sure ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                              fontFamily: 'PermanentMarker',
                            ),
                          ),
                        ),
                        content: Container(
                          height: DeviceInfo.deviceHeight(context) * 0.1,
                          width: DeviceInfo.deviceWidth(context) * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  Response deletionAttempt =
                                      await RequestHandler.sendPost(
                                    {
                                      'username': (await GlobalFunctions
                                          .getCredentials())[0],
                                      'password': (await GlobalFunctions
                                          .getCredentials())[1],
                                    },
                                    'http://192.168.1.142:8090/self-delete-account',
                                  );

                                  File loginFile = File(
                                    await GlobalFunctions.getTempPath(
                                        'login_file.txt'),
                                  );
                                  loginFile.writeAsString('');

                                  GlobalFunctions.navigate(
                                    context,
                                    LoginPage(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white10, elevation: 0),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize:
                                        DeviceInfo.deviceWidth(context) * 0.06,
                                    fontFamily: 'PermanentMarker',
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                  DeviceInfo.deviceWidth(context) * 0.1,
                                  0,
                                  0,
                                  0,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white10,
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize:
                                          DeviceInfo.deviceWidth(context) *
                                              0.06,
                                      fontFamily: 'PermanentMarker',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icons.delete,
                iconColor: Colors.redAccent,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.6,
              left: 0,
              right: 0,
              child: CustomIconButton(
                text: 'Change Password',
                textColor: Colors.yellowAccent,
                icon: Icons.vpn_key_sharp,
                iconColor: Colors.yellowAccent,
                callBack: () {
                  GlobalFunctions.navigate(
                    context,
                    ChangePassword(userName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
