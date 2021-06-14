import './main.dart';

import 'package:flutter/material.dart';



class CustomIconButton extends StatelessWidget {
  final String text;
  final Function callBack;
  final Color textColor;
  final Color iconColor;
  final IconData icon;

  CustomIconButton({
    @required this.text,
    @required this.callBack,
    @required this.textColor,
    @required this.iconColor,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        callBack();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              0,
              0,
              DeviceInfo.deviceWidth(context) * 0.1,
              0,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                fontFamily: 'PermanentMarker',
              ),
            ),
          ),
          Icon(
            icon,
            color: iconColor,
            size: DeviceInfo.deviceWidth(context) * 0.12,
          ),
        ],
      ),
    );
  }
}
