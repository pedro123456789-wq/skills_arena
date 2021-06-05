import './main.dart';
import './text_input.dart';
import './request_handler.dart';
import './email_confirmation_code.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';



class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();
  String errorMessage = '';

  Future<bool> isEmailValid(String email) async {
    if (email.contains('@')) {
      String ending = email.split('@')[1];

      if (ending.contains('.')) {
        return true;
      }
    }
    return false;
  }

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
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.13,
              left: 0,
              right: 0,
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.06,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.25,
              left: 0,
              right: 0,
              child: TextInput(
                usernameController,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Username',
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.35,
              left: 0,
              right: 0,
              child: TextInput(
                emailController,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Email',
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.45,
              left: 0,
              right: 0,
              child: TextInput(
                passwordController,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Password',
                isPassword: true,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.55,
              left: 0,
              right: 0,
              child: TextInput(
                passwordConfirmController,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Confirm Password',
                isPassword: true,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.8,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  if (passwordController.text.length < 8) {
                    setState(() {
                      errorMessage =
                          'The password must have more than 7 characters';
                    });
                  } else if (passwordController.text !=
                      passwordConfirmController.text) {
                    setState(() {
                      errorMessage = 'The two passwords do not match';
                    });
                  } else if (await isEmailValid(emailController.text) ==
                      false) {
                    setState(
                      () {
                        errorMessage = 'Invalid Email Format';
                      },
                    );
                  } else {
                    Response response = await RequestHandler.sendPost(
                      {
                        'username': usernameController.text,
                        'email': emailController.text.replaceAll(' ', ''),
                        'password': passwordController.text,
                      },
                      'http://192.168.1.142:8090/create-user',
                    );

                    if (response.statusCode == 200) {
                      GlobalFunctions.navigate(
                        context,
                        EmailConfirmationCode(usernameController.text),
                      );
                    } else {
                      setState(
                        () {
                          errorMessage = response.body;
                        },
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.redAccent,
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
