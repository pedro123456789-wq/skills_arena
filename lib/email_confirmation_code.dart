import './main.dart';
import './text_input.dart';
import './request_handler.dart';
import 'package:http/http.dart';
import './login_page.dart';

import 'package:flutter/material.dart';


class EmailConfirmationCode extends StatefulWidget {
  final String username;
  EmailConfirmationCode(this.username);

  @override
  _EmailConfirmationCodeState createState() => _EmailConfirmationCodeState();
}

class _EmailConfirmationCodeState extends State<EmailConfirmationCode> {
  TextEditingController confirmationCodeController =
      new TextEditingController();
  bool isError = false;

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
                'Email Confirmation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.15,
              left: 0,
              right: 0,
              child: Text(
                'The confirmation code should be in your inbox',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            if (isError)
              Positioned(
                top: DeviceInfo.deviceHeight(context) * 0.3,
                left: 0,
                right: 0,
                child: Text(
                  'Invalid Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.45,
              left: 0,
              right: 0,
              child: TextInput(
                confirmationCodeController,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Confirmation code',
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.8,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  Response response = await RequestHandler.sendPost(
                    {
                      'code': confirmationCodeController.text,
                      'username': widget.username,
                    },
                    'http://192.168.1.142:8090/verify-user',
                  );

                  if (response.statusCode == 200) {
                    GlobalFunctions.navigate(
                      context,
                      LoginPage(),
                    );
                  } else {
                    setState(
                      () {
                        isError = true;
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Create Account',
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
