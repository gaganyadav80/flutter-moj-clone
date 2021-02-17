import 'dart:async';
import 'package:camera/camera.dart';
import 'package:edverhub_video_editor/ui/pages/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/pages/edit_video_screen.dart';

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

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({Key key}) : super(key: key);

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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditVideoScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
