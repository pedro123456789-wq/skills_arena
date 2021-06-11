import './main.dart';

import 'package:flutter/material.dart';

class SwipeBackDetector extends StatelessWidget {
  final Widget destination;
  final Widget child;
  final Function callback;

  SwipeBackDetector(
    this.destination, {
    this.child,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    Widget detector;

    (child != null)
        ? detector = GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.swipe,
                  color: Colors.grey,
                  size: DeviceInfo.deviceWidth(context) * 0.12,
                ),
                Container(
                  width: DeviceInfo.deviceWidth(context) * 0.8,
                  child: child,
                )
              ],
            ),
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity > 0) {
                GlobalFunctions.navigate(context, destination);
              }

              if (callback != null){
                callback();
              }
            },
          )
        : detector = GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity > 0) {
                GlobalFunctions.navigate(context, destination);
              }

              if (callback != null){
                callback();
              }
            },
          );
    return detector;
  }
}
