import './main.dart';
import './navigation_bar.dart';
import './request_handler.dart';

import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class TrainingAreas extends StatefulWidget {
  @override
  _TrainingAreasState createState() => _TrainingAreasState();
}

class _TrainingAreasState extends State<TrainingAreas> {
  Future futureFunction;

  Future<File> getImage() async {
    //get position
    Position currentPosition = await Geolocator.getCurrentPosition(
      timeLimit: Duration(seconds: 1),
    );

    double latitude = currentPosition.latitude;
    double longitude = currentPosition.longitude;

    print(latitude);
    print(longitude);

    //send request to server
    Response response = await RequestHandler.sendPost(
      {'latitude': latitude.toString(), 'longitude': longitude.toString()},
      'http://192.168.1.142:8085/find_parks',
    );

    //save response bytes to image file
    File outputFile = File(
      await GlobalFunctions.getTempPath('training_areas.png'),
    );

    outputFile.writeAsBytes(response.bodyBytes);

    //return image file
    return outputFile;
  }

  @override
  void initState() {
    futureFunction = getImage();
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
                'Training Areas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              child: FutureBuilder(
                future: futureFunction,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: [
                        Positioned(
                          top: DeviceInfo.deviceHeight(context) * 0.15,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: DeviceInfo.deviceWidth(context) * 0.9,
                            height: DeviceInfo.deviceHeight(context) * 0.5,
                            child: InteractiveViewer(
                              panEnabled: true,
                              constrained: true,
                              minScale: 1,
                              maxScale: 3,
                              child: Image.file(
                                snapshot.data,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: DeviceInfo.deviceHeight(context) * 0.68,
                          left: 0,
                          right: 0,
                          child: Text(
                            'The areas highlighted in red show parks that may be good training areas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: DeviceInfo.deviceWidth(context) * 0.05,
                              fontFamily: 'PermanentMarker',
                            ),
                          ),
                        ),
                      ],
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
                            'Loading Image...',
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
            ),
          ],
        ),
      ),
    );
  }
}
