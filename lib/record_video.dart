import './main.dart';
import './video_preview.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';



Stream<int> stopWatchStream() {
  StreamController<int> streamController;
  Timer timer;
  Duration timerInterval = Duration(seconds: 1);
  int counter = 0;

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
      counter = 0;
      streamController.close();
    }
  }

  void tick(_) {
    counter++;
    streamController.add(counter);
  }

  void pauseTimer() {
    timer.cancel();
    timer = null;
  }

  void startTimer() {
    timer = Timer.periodic(timerInterval, tick);
  }

  streamController = StreamController<int>(
    onListen: startTimer,
    onCancel: stopTimer,
    onResume: startTimer,
    onPause: pauseTimer,
  );

  return streamController.stream;
}

class RecordVideo extends StatefulWidget {
  @override
  _RecordVideoState createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo>
    with AutomaticKeepAliveClientMixin {
  List<CameraDescription> cameras;
  CameraController controller;
  bool isRecording = false;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  Timer timer;
  int secondCounter = 0;

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

  Future<void> forceStoppage() async {
    await stopVideoRecording();
    timerSubscription.cancel();
    GlobalFunctions.navigate(
      context,
      VideoPreview(
        await GlobalFunctions.getTempPath(
          'skill_recording.mp4',
        ),
      ),
    );
  }

  @override
  void initState() {
    _initCamera();

    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen(
      (int newTick) {
        if (this.mounted) {
          if (secondCounter < 15) {
            setState(
              () {
                secondCounter = newTick;
              },
            );
          } else {
            setState(() {
              isRecording = false;
            });
            forceStoppage();
          }
        }
      },
    );

    timerSubscription.pause();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    timer?.cancel();
    timerSubscription.cancel();
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
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.1,
              left: 0,
              right: 0,
              child: Text(
                'The recording must be less than 15 seconds',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.04,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            (controller != null)
                ? Positioned(
                    top: DeviceInfo.deviceHeight(context) * 0.18,
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
              top: DeviceInfo.deviceHeight(context) * 0.78,
              left: 0,
              right: 0,
              child: Text(
                'Duration (seconds): $secondCounter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.07,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.85,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (!isRecording)
                      ? ElevatedButton(
                          onPressed: () async {
                            timerSubscription.resume();
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
                            timerSubscription.cancel();
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
                            Icons.stop_circle_outlined,
                            color: Colors.redAccent,
                            size: DeviceInfo.deviceWidth(context) * 0.15,
                          ),
                        ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!isRecording) {
                        await _onCameraSwitch();
                      }
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
