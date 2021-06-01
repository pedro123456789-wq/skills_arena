import './main.dart';
import './navigation_bar.dart';
import './request_handler.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'dart:math';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int futureIndex = 0;
  Future currentFuture;

  List<double> convertToPercentages(List<double> values, double maxValue) {
    List<double> percentages = [];

    for (double value in values) {
      percentages.add(value / maxValue);
    }

    return percentages;
  }

  Future<Widget> getDistances(BuildContext context) async {
    //send request to database to get user records
    Response databaseResponse = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1],
      },
      'http://192.168.1.142:8090/get-distances-ran',
    );

    String databaseData = databaseResponse.body;
    List<String> distanceData = databaseData.split('\n');
    distanceData = distanceData.sublist(1, distanceData.length);

    Map<String, double> longDistances = {};
    Map<String, double> sprints = {};
    List<String> dates = [];

    for (String distance in distanceData) {
      double distanceKm = double.parse(distance.split('-')[0]);
      String date = distance.split('-')[1];
      String type = distance.split('-')[2];

      Map outputMap;

      if (type == 'LongDistance') {
        outputMap = longDistances;
      } else {
        outputMap = sprints;
      }

      if (outputMap.keys.contains(date)) {
        outputMap[date] += distanceKm;
      } else {
        outputMap[date] = distanceKm;
        if (dates.contains(date) == false) {
          dates.add(date);
        }
      }
    }

    List<double> longDistancesTotals = [];
    List<double> sprintTotals = [];
    List<double> dailyTotals = [];

    for (String date in dates) {
      double longDistance;
      double sprintDistance;

      if (longDistances.keys.contains(date)) {
        longDistance = longDistances[date];
      } else {
        longDistance = 0;
      }

      if (sprints.keys.contains(date)) {
        sprintDistance = sprints[date];
      } else {
        sprintDistance = 0;
      }

      longDistancesTotals.add(longDistance);
      sprintTotals.add(sprintDistance);
      dailyTotals.add(
        longDistance + sprintDistance,
      );
    }

    double maxValue = dailyTotals.reduce(max);

    //generate axis labels for line graph
    int increments;

    List<String> yLabels = [];
    if (maxValue / 10 < 1) {
      increments = 1;
    } else {
      increments = (maxValue / 10).round();
    }

    maxValue = increments.toDouble() * 10;
    for (int i = increments; i <= maxValue; i += increments) {
      yLabels.add(
        i.toString(),
      );
    }

    List<String> xLabels = [
      dates[0],
    ];

    for (double i = 1; i < dates.length - 1; i++) {
      xLabels.add('');
    }

    xLabels.add('Today');

    List<Feature> features = [
      Feature(
        title: 'Total',
        data: convertToPercentages(dailyTotals, maxValue),
        color: Colors.purpleAccent,
      ),
      Feature(
        title: 'Long Distance',
        data: convertToPercentages(longDistancesTotals, maxValue),
        color: Colors.blue,
      ),
      Feature(
        title: 'Sprints',
        data: convertToPercentages(sprintTotals, maxValue),
        color: Colors.cyanAccent,
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            DeviceInfo.deviceHeight(context) * 0.07,
          ),
          child: Text(
            'Distance Ran (Km)',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: DeviceInfo.deviceWidth(context) * 0.08,
              fontFamily: 'PermanentMarker',
            ),
          ),
        ),
        LineGraph(
          features: features,
          showDescription: true,
          size: Size(
            DeviceInfo.deviceWidth(context) * 1,
            DeviceInfo.deviceHeight(context) * 0.5,
          ),
          labelX: xLabels,
          labelY: yLabels,
          graphColor: Colors.redAccent,
          fontFamily: 'PermanentMarker',
          textColor: Colors.redAccent,
        ),
      ],
    );
  }

  Future<Widget> getDurations(BuildContext context) async {
    //send request to database to get user records
    Response databaseResponse = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1]
      },
      'http://192.168.1.142:8090/get-workout-data',
    );

    //parse response data
    String databaseData = databaseResponse.body;
    List<String> durationData = databaseData.split('\n');
    durationData = durationData.sublist(1, durationData.length);

    Map<String, double> physicalDurations = {};
    Map<String, double> technicalDurations = {};
    List<String> dates = [];

    for (String session in durationData) {
      double duration = double.parse(session.split('-')[0]);
      String date = session.split('-')[1];
      String type = session.split('-')[2];
      Map outputFile;

      if (type == 'Session') {
        outputFile = technicalDurations;
      } else {
        outputFile = physicalDurations;
      }

      if (outputFile.keys.contains(date)) {
        outputFile[date] += duration;
      } else {
        outputFile[date] = duration;
        if (dates.contains(date) == false) {
          dates.add(date);
        }
      }
    }

    List<double> dailyPhysical = [];
    List<double> dailyTechnical = [];
    List<double> dailyTotal = [];

    for (String date in dates) {
      double physicalDuration;
      double technicalDuration;

      if (physicalDurations.keys.contains(date)) {
        physicalDuration = physicalDurations[date];
      } else {
        physicalDuration = 0;
      }

      if (technicalDurations.keys.contains(date)) {
        technicalDuration = technicalDurations[date];
      } else {
        technicalDuration = 0;
      }

      dailyPhysical.add(physicalDuration);
      dailyTechnical.add(technicalDuration);
      dailyTotal.add(physicalDuration + technicalDuration);
    }

    double maxValue = dailyTotal.reduce(max);

    //generate axis labels for line graph
    int increments;

    List<String> yLabels = [];
    if (maxValue / 10 < 1) {
      increments = 1;
    } else {
      increments = (maxValue / 10).round();
    }

    maxValue = increments.toDouble() * 10;
    for (int i = increments; i <= maxValue; i += increments) {
      yLabels.add(
        i.toString(),
      );
    }

    List<String> xLabels = [
      dates[0],
    ];

    for (double i = 1; i < dates.length - 1; i++) {
      xLabels.add('');
    }

    xLabels.add('Today');

    //add data for line chart
    List<Feature> features = [
      Feature(
        title: 'Total',
        data: convertToPercentages(dailyTotal, maxValue),
        color: Colors.purpleAccent,
      ),
      Feature(
        title: 'Technical Training',
        data: convertToPercentages(dailyTechnical, maxValue),
        color: Colors.blue,
      ),
      Feature(
        title: 'Physical Training',
        data: convertToPercentages(dailyPhysical, maxValue),
        color: Colors.cyanAccent,
      ),
    ];

    //build lineGraph
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            DeviceInfo.deviceHeight(context) * 0.07,
          ),
          child: Text(
            'Time Trained (minutes)',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: DeviceInfo.deviceWidth(context) * 0.08,
              fontFamily: 'PermanentMarker',
            ),
          ),
        ),
        LineGraph(
          features: features,
          showDescription: true,
          size: Size(
            DeviceInfo.deviceWidth(context) * 1,
            DeviceInfo.deviceHeight(context) * 0.5,
          ),
          labelX: xLabels,
          labelY: yLabels,
          graphColor: Colors.redAccent,
          fontFamily: 'PermanentMarker',
          textColor: Colors.redAccent,
        ),
      ],
    );
  }

  @override
  void initState() {
    currentFuture = getDurations(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDurations(context);
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
              child: FutureBuilder(
                future: currentFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data;
                  } else {
                    return Container(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        DeviceInfo.deviceHeight(context) * 0.4,
                        0,
                        0,
                      ),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                          ),
                          Text(
                            'Loading Data...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                              fontFamily: 'PermanentMarker',
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.7,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      if (futureIndex == 0) {
                        currentFuture = getDistances(context);
                        futureIndex = 1;
                      } else {
                        currentFuture = getDurations(context);
                        futureIndex = 0;
                      }
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.greenAccent,
                  size: DeviceInfo.deviceWidth(context) * 0.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}