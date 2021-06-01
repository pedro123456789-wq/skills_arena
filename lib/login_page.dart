import './main.dart';
import './text_input.dart';
import './request_handler.dart';
import './landing_page.dart';
import './create_account_page.dart';

import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isInvalid = false;

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
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            if (isInvalid)
              Positioned(
                top: DeviceInfo.deviceHeight(context) * 0.08,
                left: 0,
                right: 0,
                child: Text(
                  'Invalid Credentials',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.06,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.13,
              left: 0,
              right: 0,
              child: Image(
                image: AssetImage('assets/login_image.png'),
                height: DeviceInfo.deviceHeight(context) * 0.35,
                width: DeviceInfo.deviceWidth(context) * 0.95,
                alignment: Alignment.center,
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.55,
              left: 0,
              right: 0,
              child: TextInput(
                usernameController,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Username',
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.65,
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
              top: DeviceInfo.deviceHeight(context) * 0.78,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  Response response = await RequestHandler.sendPost(
                    {
                      'username': usernameController.text,
                      'password': passwordController.text
                    },
                    'http://192.168.1.142:8090/authenticate-user',
                  );

                  if (response.body == 'Authenticated') {
                    File outputFile = File(
                        await GlobalFunctions.getTempPath('login_file.txt'));
                    outputFile.writeAsString(
                        '${usernameController.text}, ${passwordController.text}');
                    GlobalFunctions.navigate(context, LandingPage());
                  } else {
                    setState(() {
                      isInvalid = true;
                    });
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
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.9,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  GlobalFunctions.navigate(
                    context,
                    CreateAccountPage(),
                  );
                },
                style: ElevatedButton.styleFrom(primary: Colors.black),
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.05,
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
