import './main.dart';
import './request_handler.dart';
import './navigation_bar.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

//TODO: Fix Video player to make it display the videos

class DisplaySkill extends StatefulWidget {
  final String skillName;

  DisplaySkill(
    this.skillName,
  );

  @override
  _DisplaySkillState createState() => _DisplaySkillState();
}

class _DisplaySkillState extends State<DisplaySkill> {
  ChewieController chewieController;
  VideoPlayerController controller;
  Future future;

  Future<ChewieController> getSkillVideo() async {
    Response response = await RequestHandler.sendPost(
      {
        'username': (await GlobalFunctions.getCredentials())[0],
        'password': (await GlobalFunctions.getCredentials())[1],
        'skill_name': widget.skillName
      },
      'http://192.168.1.142:8090/get-skill-video',
    );

    File outputFile = File(
      await GlobalFunctions.getTempPath('output_video.mp4'),
    );

    await outputFile.writeAsBytes(
      response.bodyBytes,
    );

    chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.file(outputFile),
      autoInitialize: true,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
    );

    return chewieController;
  }

  @override
  void initState() {
    super.initState();
    future = getSkillVideo();
  }

  @override
  void dispose() {
    chewieController.videoPlayerController.removeListener(
      () {
        setState(() {});
      },
    );
    chewieController.videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
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
                widget.skillName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.15,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: DeviceInfo.deviceHeight(context) * 0.5,
                      width: DeviceInfo.deviceWidth(context),
                      child: Chewie(
                        controller: snapshot.data,
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
                          'Loading Video...',
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
