import './main.dart';
import './record_video.dart';
import './add_new_skill.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class VideoPreview extends StatefulWidget {
  final String videoPath;

  VideoPreview(
    this.videoPath,
  );

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  ChewieController chewieController;
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(
      File(widget.videoPath),
    )..initialize().then(
        (_) {
          setState(() {});
        },
      );

    chewieController = ChewieController(
      videoPlayerController: controller,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
    chewieController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.01,
              left: 0,
              right: 0,
              child: Text(
                'Video Preview',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            (controller != null)
                ? Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.15,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: DeviceInfo.deviceHeight(context) * 0.6,
                      width: DeviceInfo.deviceWidth(context),
                      child: Chewie(controller: chewieController),
                    ),
                  )
                : Stack(
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
                  ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      GlobalFunctions.navigate(
                        context,
                        RecordVideo(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: DeviceInfo.deviceWidth(context) * 0.12,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      GlobalFunctions.navigate(
                        context,
                        AddNewSkill(
                          isVideoSelected: true,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Icon(
                      Icons.save,
                      color: Colors.greenAccent,
                      size: DeviceInfo.deviceWidth(context) * 0.12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
