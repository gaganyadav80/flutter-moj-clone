import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:edverhub_video_editor/ui/pages/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'ui/pages/edit_video/edit_video_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(CameraApp());
}

// class CameraExampleHome extends StatefulWidget {
//   @override
//   _CameraExampleHomeState createState() {
//     return _CameraExampleHomeState();
//   }
// }

/// Returns a suitable camera icon for [direction].

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChooseScreen(),
    );
  }
}

class ChooseScreen extends StatefulWidget {
  const ChooseScreen({Key key}) : super(key: key);

  @override
  _ChooseScreenState createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  final _picker = ImagePicker();
  File _video;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(_video);
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      showControls: false,
      allowedScreenSleep: false,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Video Editor"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(
                child: Text("Record Video"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraExampleHome(
                      cameras: cameras,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text("Browse from gallery"),
                onPressed: () async {
                  PickedFile pickedFile = await _picker.getVideo(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    _video = File(pickedFile.path);
                    await _initVideo();
                  } else {
                    print("No video file selected");
                  }

                  if (_video != null)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditVideoScreen(
                          video: _video,
                          videoPlayerController: _videoPlayerController,
                          chewieController: _chewieController,
                        ),
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
