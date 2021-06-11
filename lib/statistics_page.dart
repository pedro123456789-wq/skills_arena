import 'package:flutter/gestures.dart';

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

  List<String> getDatesInRange(DateTime startingDate, DateTime endingDate) {
    List<String> days = [];

    for (int i = 0; i <= endingDate.difference(startingDate).inDays; i++) {
      DateTime currentDay =
          DateTime(startingDate.year, startingDate.month, startingDate.day + i);

      days.add('${currentDay.day}/${currentDay.month}/${currentDay.year}');
    }

    return days;
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
    String firstDate = distanceData[0].split('-')[1];

    //initialize dictionaries to store distances ran in different dates
    Map<String, double> longDistances = {};
    Map<String, double> sprints = {};
    Map<String, double> totals = {};

    //get all dates between starting and ending date
    List<String> dates = getDatesInRange(
      DateTime(
        int.parse(
          firstDate.split('/')[2],
        ),
        int.parse(
          firstDate.split('/')[1],
        ),
        int.parse(
          firstDate.split('/')[0],
        ),
      ),
      DateTime.now(),
    );

    //initialize all dates in all dictionaries
    for (String date in dates) {
      longDistances[date] = 0;
      sprints[date] = 0;
      totals[date] = 0;
    }

    //add distance ran to each date
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

      outputMap[date] += distanceKm;
      totals[date] += distanceKm;
    }

    //convert dictionaries into lists
    List<double> longDistancesList = [];
    List<double> sprintsList = [];
    List<double> totalsList = [];

    longDistances.forEach((key, value) => longDistancesList.add(value));
    sprints.forEach((key, value) => sprintsList.add(value));
    totals.forEach((key, value) => totalsList.add(value));

    //calculate max value and use it to calculate percentages for y-axis labels
    double maxValue = totalsList.reduce(max);

    //generate axis labels for line graph
    int increments;

    //add y-axis labels
    List<String> yLabels = [];
    if (maxValue / 10 < 1) {
      increments = 1;
    } else {
      increments = (maxValue / 10).round();
    }

    //calculate y-increments
    maxValue = increments.toDouble() * 10;
    for (int i = increments; i <= maxValue; i += increments) {
      yLabels.add(
        i.toString(),
      );
    }

    //create list with x labels (starting and ending date)
    List<String> xLabels = [
      dates[0],
    ];

    for (double i = 1; i < dates.length - 1; i++) {
      xLabels.add('');
    }

    xLabels.add('Today');

    //add data to feature list as separate sub-plots
    List<Feature> features = [
      Feature(
        title: 'Total',
        data: convertToPercentages(totalsList, maxValue),
        color: Colors.purpleAccent,
      ),
      Feature(
        title: 'Long Distance',
        data: convertToPercentages(longDistancesList, maxValue),
        color: Colors.blue,
      ),
      Feature(
        title: 'Sprints',
        data: convertToPercentages(sprintsList, maxValue),
        color: Colors.cyanAccent,
      ),
    ];

    //return column with labels and graph with data
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
        'password': (await GlobalFunctions.getCredentials())[1],
      },
      'http://192.168.1.142:8090/get-workout-data',
    );

    String databaseData = databaseResponse.body;
    List<String> distanceData = databaseData.split('\n');
    distanceData = distanceData.sublist(1, distanceData.length);
    String firstDate = distanceData[0].split('-')[1];

    //initialize dictionaries to store distances ran in different dates
    Map<String, double> physicalDurations = {};
    Map<String, double> technicalDurations = {};
    Map<String, double> totals = {};

    //get all dates between starting and ending date
    List<String> dates = getDatesInRange(
      DateTime(
        int.parse(
          firstDate.split('/')[2],
        ),
        int.parse(
          firstDate.split('/')[1],
        ),
        int.parse(
          firstDate.split('/')[0],
        ),
      ),
      DateTime.now(),
    );

    //initialize all dates in all dictionaries
    for (String date in dates) {
      physicalDurations[date] = 0;
      technicalDurations[date] = 0;
      totals[date] = 0;
    }

    //add distance ran to each date
    for (String distance in distanceData) {
      double distanceKm = double.parse(distance.split('-')[0]);
      String date = distance.split('-')[1];
      String type = distance.split('-')[2];

      Map outputMap;

      if (type == 'Physical') {
        outputMap = physicalDurations;
      } else {
        outputMap = technicalDurations;
      }

      outputMap[date] += distanceKm;
      totals[date] += distanceKm;
    }

    //convert dictionaries into lists
    List<double> physicalList = [];
    List<double> technicalList = [];
    List<double> totalsList = [];

    physicalDurations.forEach((key, value) => physicalList.add(value));
    technicalDurations.forEach((key, value) => technicalList.add(value));
    totals.forEach((key, value) => totalsList.add(value));

    //calculate max value and use it to calculate percentages for y-axis labels
    double maxValue = totalsList.reduce(max);

    //generate axis labels for line graph
    int increments;

    //add y-axis labels
    List<String> yLabels = [];
    if (maxValue / 10 < 1) {
      increments = 1;
    } else {
      increments = (maxValue / 10).round();
    }

    //calculate y-increments
    maxValue = increments.toDouble() * 10;
    for (int i = increments; i <= maxValue; i += increments) {
      yLabels.add(
        i.toString(),
      );
    }

    //create list with x labels (starting and ending date)
    List<String> xLabels = [
      dates[0],
    ];

    for (double i = 1; i < dates.length - 1; i++) {
      xLabels.add('');
    }

    xLabels.add('Today');

    //add data to feature list as separate sub-plots
    List<Feature> features = [
      Feature(
        title: 'Total',
        data: convertToPercentages(totalsList, maxValue),
        color: Colors.purpleAccent,
      ),
      Feature(
        title: 'Physical',
        data: convertToPercentages(physicalList, maxValue),
        color: Colors.blue,
      ),
      Feature(
        title: 'Technical',
        data: convertToPercentages(technicalList, maxValue),
        color: Colors.cyanAccent,
      ),
    ];

    //return column with labels and graph with data
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
    getDistances(context);
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
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragEnd: (DragEndDetails details) {
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
                child: Container(
                  width: DeviceInfo.deviceWidth(context),
                  child: Icon(
                    Icons.swipe,
                    color: Colors.greenAccent,
                    size: DeviceInfo.deviceWidth(context) * 0.15,
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
