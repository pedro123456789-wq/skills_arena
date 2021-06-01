import './main.dart';

import 'package:flutter/material.dart';


class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    void press(int number) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppGlobals.routes[number]),
      );

      setState(
        () {
          AppGlobals.navigationBarIndex = number;
        },
      );
    }

    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.redAccent,
      selectedIconTheme: IconThemeData(color: Colors.greenAccent),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'PermanentMarker',
        fontSize: DeviceInfo.deviceWidth(context) * 0.04,
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.grey,
        fontSize: DeviceInfo.deviceWidth(context) * 0.03,
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      type: BottomNavigationBarType.fixed,
      currentIndex: AppGlobals.navigationBarIndex,
      onTap: press,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on_sharp,
              //color: Colors.redAccent,
              size: DeviceInfo.deviceWidth(context) * 0.13,
            ),
            label: 'Locations'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.sports_soccer,
              //color: Colors.redAccent,
              size: DeviceInfo.deviceWidth(context) * 0.22,
            ),
            label: 'Train'),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart,
            //color: Colors.redAccent,
            size: DeviceInfo.deviceWidth(context) * 0.13,
          ),
          label: 'Stats',
        ),
      ],
    );
  }
}
