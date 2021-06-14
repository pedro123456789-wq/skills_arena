import './main.dart';
import './user_profile.dart';
import './swipe_back_detector.dart';
import './text_input.dart';
import './request_handler.dart';

import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  final String userName;

  ChangePassword(
    this.userName,
  );

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController p1Controller = new TextEditingController();
  TextEditingController p2Controller = new TextEditingController();

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
              child: SwipeBackDetector(
                UserProfile(widget.userName),
                child: Text(
                  'Change Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.35,
              left: 0,
              right: 0,
              child: TextInput(
                p1Controller,
                DeviceInfo.deviceWidth(context) * 0.08,
                'New Password',
                isPassword: true,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.5,
              left: 0,
              right: 0,
              child: TextInput(
                p2Controller,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Re-enter new password',
                isPassword: true,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.8,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  String password1 = p1Controller.text;
                  String password2 = p2Controller.text;

                  //check if user entered something for both input fields
                  if (password1.length > 0 && password2.length > 0) {

                    //check if the two passwords match
                    if (password1 == password2) {

                      //check if the passwords are longer than 7 characters
                      if (password1.length > 7) {
                        Response changeRequest = await RequestHandler.sendPost(
                          {
                            'username':
                                (await GlobalFunctions.getCredentials())[0],
                            'password':
                                (await GlobalFunctions.getCredentials())[1],
                            'new_password': password1
                          },
                          'http://192.168.1.142:8090/change-password',
                        );

                        //check if request to the database was successful
                        if (changeRequest.statusCode == 200) {
                          GlobalFunctions.showSnackBar(
                            context,
                            'Password successfully changed',
                            textColor: Colors.greenAccent,
                          );

                          //save new password to file
                          String username =
                              (await GlobalFunctions.getCredentials())[0];
                          File loginFile = File(
                            await GlobalFunctions.getTempPath('login_file.txt'),
                          );

                          loginFile.writeAsString(
                            '$username $password1',
                          );

                          //navigate to account settings again
                          GlobalFunctions.navigate(
                            context,
                            UserProfile(widget.userName),
                          );
                        } else {
                          //show database request error
                          GlobalFunctions.showSnackBar(
                            context,
                            changeRequest.body,
                          );
                        }
                      } else {
                        //show password length error
                        GlobalFunctions.showSnackBar(
                          context,
                          'The password must have more than 7 characters',
                        );
                      }
                    } else {
                      //show error due to password mismatch
                      GlobalFunctions.showSnackBar(
                        context,
                        'The two passwords do not match',
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.yellowAccent,
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
