import './main.dart';
import './navigation_bar.dart';
import './free_session_manager.dart';
import './swipe_back_detector.dart';
import './technical_training.dart';

import 'package:flutter/material.dart';


class FreeSession extends StatelessWidget {
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
              child: SwipeBackDetector(
                TechnicalTraining(),
                child: Text(
                  'Free Session',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.15,
              left: 0,
              right: 0,
              bottom: DeviceInfo.deviceHeight(context) * 0.08,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Track your session Live \n\n\n Every time you finish an exercise say \'Completed\' followed by the exercise name followed by the number of repetitions to record it. For example you can say \'Done fifty kick ups\' \n\n\n Say \'Pause\' to pause the session \n\n\n Say \'Resume\' to resume the session \n\n\n Say \'Stop\' to end the session',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: DeviceInfo.deviceWidth(context) * 0.06,
                        fontFamily: 'PermanentMarker',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.715,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  GlobalFunctions.navigate(
                    context,
                    FreeSessionManager(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Text(
                  'Start Session',
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
