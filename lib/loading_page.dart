import './main.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
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
                'Skills Arena',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'PermanentMarker',
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.1,
              left: 0,
              right: 0,
              child: Text(
                'Train Without Limits',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.06,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.1,
              left: 0,
              right: 0,
              child: Image(
                image: AssetImage('assets/loading_image.png'),
                height: DeviceInfo.deviceHeight(context) * 0.8,
                width: DeviceInfo.deviceWidth(context),
                alignment: Alignment.center,
                colorBlendMode: BlendMode.darken,
              ),
            )
          ],
        ),
      ),
    );
  }
}
