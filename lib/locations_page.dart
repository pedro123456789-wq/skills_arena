import './main.dart';
import './navigation_bar.dart';
import './training_areas.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

//fix permissions
class LocationsPage extends StatefulWidget {
  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  Future futurePointer;
  double locationLatitude;
  double locationLongitude;


  Future getCurrentPosition() async {
    PermissionStatus permission = await Permission.location.status;

    if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
      timeLimit: Duration(
        seconds: 5,
      ),
    );

    return [currentPosition.latitude, currentPosition.longitude];
  }


  @override
  void initState() {
    futurePointer = getCurrentPosition();
    super.initState();
  }


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
                'Training \n Locations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.03,
              left: 0,
              child: ElevatedButton(
                onPressed: () async {
                  GlobalFunctions.navigate(
                    context,
                    TrainingAreas(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Icon(
                  Icons.park,
                  color: Colors.redAccent,
                  size: DeviceInfo.deviceWidth(context) * 0.15,
                ),
              ),
            ),
            FutureBuilder(
              future: futurePointer,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.2,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: DeviceInfo.deviceHeight(context) * 0.65,
                      width: DeviceInfo.deviceWidth(context) * 0.8,
                      child: FlutterMap(
                        options: MapOptions(
                          center: latLng.LatLng(
                            snapshot.data[0],
                            snapshot.data[1],
                          ),
                          zoom: 15,
                        ),
                        layers: [
                          TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c']),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: DeviceInfo.deviceWidth(context) * 0.05,
                                height: DeviceInfo.deviceHeight(context) * 0.05,
                                point: latLng.LatLng(
                                  snapshot.data[0],
                                  snapshot.data[1],
                                ),
                                builder: (context) => Container(
                                  child: Icon(
                                    Icons.location_on_sharp,
                                    color: Colors.redAccent,
                                    size:
                                        DeviceInfo.deviceWidth(context) * 0.05,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Stack(
                    children: [
                      Positioned(
                        top: DeviceInfo.deviceHeight(context) * 0.45,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      Positioned(
                        top: DeviceInfo.deviceHeight(context) * 0.5,
                        left: 0,
                        right: 0,
                        child: Text(
                          'Loading Map...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                            fontFamily: 'PermanentMarker',
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
