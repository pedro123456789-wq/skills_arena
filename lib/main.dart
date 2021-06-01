import './landing_page.dart';
import './locations_page.dart';
import './statistics_page.dart';
import './request_handler.dart';
import './login_page.dart';
import './loading_page.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import 'dart:io' as io;

//finish login page and migrate to db instead of file storage

void main() {
  runApp(App());
}

class DeviceInfo {
  static double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double deviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
}

class AppGlobals {
  //navigation bar globals
  static int navigationBarIndex = 1;
  static List<Widget> routes = [
    LocationsPage(),
    LandingPage(),
    StatsPage(),
  ];

  //technical sessions
  static List<String> exercisesList = [];
  static List<int> exerciseDurations = [];
  static String sessionName = 'Session Name';
  static bool isSessionPaused = false;

  //physical sessions
  static List<String> workoutList = [];
  static List<int> workoutDurations = [];
  static String workoutName = 'Workout Name';

  //free sessions
  static List<int> exerciseRepetitions = [];

  //sprinting sessions
  static List<double> sprintDistances = [];
}

class GlobalFunctions {
  static Future<String> getTempPath(String path) async {
    io.Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$path';

    return filePath;
  }

  static String timeString(int minutes, int seconds) {
    if (minutes != null && seconds != null) {
      if (minutes == 0) {
        return '$seconds seconds';
      } else if (seconds == 0) {
        return '$minutes minutes';
      } else {
        return '$minutes minutes and $seconds seconds';
      }
    } else {
      return '';
    }
  }

  static void navigate(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => destination,
      ),
    );
  }

  static Future<void> textToSpeech(String text) async {
    AudioPlayer audioPlayer = AudioPlayer();

    Response response = await RequestHandler.sendPost(
        {'text': text}, 'http://192.168.1.142:8085/text-to-speech');

    io.File outputFile = new io.File(
      await GlobalFunctions.getTempPath('speech.mp3'),
    );

    await outputFile.writeAsBytes(response.bodyBytes);

    audioPlayer.play(
      await GlobalFunctions.getTempPath('speech.mp3'),
      isLocal: true,
    );
  }

  static Future<List> getLocalFiles() async {
    String appDocumentsDirectory =
        (await getApplicationDocumentsDirectory()).path;
    List files = io.Directory(appDocumentsDirectory).listSync();

    return files;
  }

  static Future<Widget> isLoggedIn() async {
    io.File loginFile =
        io.File(await GlobalFunctions.getTempPath('login_file.txt'));

    String fileContents;

    if (loginFile.existsSync()) {
      fileContents = await loginFile.readAsString();
    } else {
      loginFile.createSync();
      fileContents = '';
    }

    print(fileContents);

    if (fileContents.length > 0) {
      Response response = await RequestHandler.sendPost(
        {
          'username': fileContents.split(', ')[0],
          'password': fileContents.split(', ')[1],
        },
        'http://192.168.1.142:8090/authenticate-user',
      );

      if (response.statusCode == 200) {
        return LandingPage();
      }
    }

    return LoginPage();
  }

  static Future<List<String>> getCredentials() async {
    io.File loginFile =
        io.File(await GlobalFunctions.getTempPath('login_file.txt'));

    String fileContents = await loginFile.readAsString();
    String username = fileContents.split(', ')[0];
    String password = fileContents.split(', ')[1];

    return [username, password];
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skills Arena',
      home: FutureBuilder(
        future: GlobalFunctions.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData)
            return snapshot.data; //replace with snapshot.data
          else {
            return LoadingPage();
          }
        },
      ),
    );
  }
}
