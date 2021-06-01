import './main.dart';
import './video_preview.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RecordVideo extends StatefulWidget {
  @override
  _RecordVideoState createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo>
    with AutomaticKeepAliveClientMixin {
  List<CameraDescription> cameras;
  CameraController controller;
  bool isRecording = false;

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      },
    );
  }

  Future<void> _onCameraSwitch() async {
    print('Switching Camera');
    print(cameras.length);
    final CameraDescription cameraDescription =
        (controller.description == cameras[0]) ? cameras[1] : cameras[0];
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.medium);
    controller.addListener(
      () {
        if (mounted) setState(() {});
        if (controller.value.hasError) {
          print('Error');
        }
      },
    );

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget buildCameraPreview() {
    return CameraPreview(controller);
  }

  Future<void> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return;
    }

    setState(() {
      isRecording = true;
    });

    //_timerKey.currentState.startTimer();

    if (controller.value.isRecordingVideo) {
      return;
    }

    try {
      File videoFile = File(
        await GlobalFunctions.getTempPath('skill_recording.mp4'),
      );

      videoFile.delete();
    } catch (e) {
      print('File does not yet exist');
    }

    try {
      await controller.startVideoRecording(
        await GlobalFunctions.getTempPath('skill_recording.mp4'),
      );
    } on CameraException catch (e) {
      print('Error: $e');
      return;
    }
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return;
    }

    //_timerKey.currentState.stopTimer();
    setState(
      () {
        isRecording = false;
      },
    );

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      print('Error: $e');
      return;
    }
  }

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
                'Record Video',
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
                      child: buildCameraPreview(),
                      height: DeviceInfo.deviceHeight(context) * 0.5,
                      width: DeviceInfo.deviceWidth(context) * 0.85,
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
                          'Loading Camera...',
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
                  (!isRecording)
                      ? ElevatedButton(
                          onPressed: () async {
                            await startVideoRecording();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.redAccent,
                            size: DeviceInfo.deviceWidth(context) * 0.15,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            await stopVideoRecording();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Icon(
                            Icons.stop_circle_outlined,
                            color: Colors.redAccent,
                            size: DeviceInfo.deviceWidth(context) * 0.15,
                          ),
                        ),
                  ElevatedButton(
                    onPressed: () async {
                      await _onCameraSwitch();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Icon(
                      Icons.switch_camera,
                      color: Colors.greenAccent,
                      size: DeviceInfo.deviceWidth(context) * 0.15,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      GlobalFunctions.navigate(
                        context,
                        VideoPreview(
                          await GlobalFunctions.getTempPath(
                            'skill_recording.mp4',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Icon(
                      Icons.preview,
                      color: Colors.greenAccent,
                      size: DeviceInfo.deviceWidth(context) * 0.15,
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

  @override
  bool get wantKeepAlive => true;
}
