import './main.dart';
import './text_input.dart';
import './record_video.dart';
import './request_handler.dart';
import './landing_page.dart';

import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


//TODO: Check if user has less than 5 skills saved
//TODO: Add option to delete skill


class AddNewSkill extends StatefulWidget {
  bool isVideoSelected;

  AddNewSkill({this.isVideoSelected = false});

  @override
  _AddNewSkillState createState() => _AddNewSkillState();
}

class _AddNewSkillState extends State<AddNewSkill> {
  TextEditingController skillNameController = new TextEditingController();
  ImagePicker picker = new ImagePicker();
  File selectedFile;
  bool isError = false;
  String errorMessage = 'The video is too long or too large or has an invalid format';
  VideoPlayerController controller;

  Future<void> getVideo() async {
    selectedFile = File(
      (await picker.getVideo(source: ImageSource.gallery)).path,
    );

    controller = new VideoPlayerController.file(selectedFile);
    await controller.initialize();

    print(controller.value.duration.inSeconds);

    if (controller.value.duration.inSeconds < 16) {
      setState(
        () {
          widget.isVideoSelected = true;
          isError = false;
        },
      );
    } else {
      setState(
        () {
          isError = true;
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
                'New Skill',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.1,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.2,
              left: 0,
              right: 0,
              child: TextInput(
                skillNameController,
                DeviceInfo.deviceWidth(context) * 0.08,
                'Skill Name',
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.4,
              left: 0,
              right: 0,
              child: Text(
                'Add video of skill',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.45,
              left: 0,
              right: 0,
              child: Text(
                'The video should be less than 15 seconds',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: DeviceInfo.deviceWidth(context) * 0.05,
                  fontFamily: 'PermanentMarker',
                ),
              ),
            ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.55,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      DeviceInfo.deviceWidth(context) * 0.05,
                      0,
                    ),
                    child: ElevatedButton(
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
                        Icons.camera_enhance_sharp,
                        color: Colors.greenAccent,
                        size: DeviceInfo.deviceWidth(context) * 0.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      DeviceInfo.deviceWidth(context) * 0.05,
                      0,
                      0,
                      0,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        await getVideo();
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Icon(
                        Icons.image,
                        color: Colors.greenAccent,
                        size: DeviceInfo.deviceWidth(context) * 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isVideoSelected && !isError)
              Positioned(
                top: DeviceInfo.deviceHeight(context) * 0.75,
                left: 0,
                right: 0,
                child: Text(
                  'Video Selected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            if (isError)
              Positioned(
                top: DeviceInfo.deviceHeight(context) * 0.75,
                left: 0,
                right: 0,
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.05,
                    fontFamily: 'PermanentMarker',
                  ),
                ),
              ),
            Positioned(
              top: DeviceInfo.deviceHeight(context) * 0.9,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  String skillName = skillNameController.text;

                  if (widget.isVideoSelected) {
                    Response isNameValid = await RequestHandler.sendPost(
                      {
                        'username': (await GlobalFunctions.getCredentials())[0],
                        'password': (await GlobalFunctions.getCredentials())[1],
                        'skill_name': skillName
                      },
                      'http://192.168.1.142:8090/is-skill-name-valid',
                    );

                    if (isNameValid.statusCode == 404) {
                      setState(
                        () {
                          isError = true;
                          errorMessage = 'Skill name is already in use';
                        },
                      );

                      return;
                    }

                    if (skillName.length > 0) {
                      MultipartRequest request = MultipartRequest(
                        'POST',
                        Uri.parse('http://192.168.1.142:8090/upload-video'),
                      );

                      if (selectedFile != null) {
                        request.files.add(
                          MultipartFile(
                            'video',
                            selectedFile.readAsBytes().asStream(),
                            selectedFile.lengthSync(),
                            filename: selectedFile.path,
                          ),
                        );
                      } else {
                        File outputFile = File(
                          await GlobalFunctions.getTempPath(
                            'skill_recording.mp4',
                          ),
                        );
                        request.files.add(
                          MultipartFile(
                            'video',
                            outputFile.readAsBytes().asStream(),
                            outputFile.lengthSync(),
                            filename: '$skillName.mp4',
                          ),
                        );
                      }

                      request.headers.addAll(
                        {
                          'username':
                              (await GlobalFunctions.getCredentials())[0],
                          'password':
                              (await GlobalFunctions.getCredentials())[1],
                          'skill_name': skillName,
                        },
                      );

                      Response response =
                          await Response.fromStream(await request.send());

                      if (response.statusCode == 404) {
                        setState(
                          () {
                            isError = true;
                            widget.isVideoSelected = false;
                          },
                        );
                        return;
                      }

                      Response addSkill = await RequestHandler.sendPost(
                        {
                          'username':
                              (await GlobalFunctions.getCredentials())[0],
                          'password':
                              (await GlobalFunctions.getCredentials())[1],
                          'name': skillName
                        },
                        'http://192.168.1.142:8090/add-skill',
                      );

                      if (addSkill.statusCode == 200) {
                        GlobalFunctions.navigate(
                          context,
                          LandingPage(),
                        );
                      } else {
                        setState(
                          () {
                            isError = true;
                            widget.isVideoSelected = false;
                          },
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(primary: Colors.black),
                child: Text(
                  'Save Skill',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: DeviceInfo.deviceWidth(context) * 0.08,
                    fontFamily: 'PermanentMarker',
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
