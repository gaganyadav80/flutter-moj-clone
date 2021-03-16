import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:edverhub_video_editor/ui/pages/camera_screen.dart';

import 'ui/pages/edit_video/edit_video_screen.dart';
import 'ui/pages/edit_video/ffmpeg_filters.dart';
import 'variables.dart';

void main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
    // logError(e.code, e.description);
  }
  SystemChrome.setEnabledSystemUIOverlays([]);

  appDirectory = (await getApplicationDocumentsDirectory()).path;
  final Directory _acv = Directory('$appDirectory/acv/');
  final Directory _imgs = Directory('$appDirectory/img/');
  if ((await _acv.exists() == false) && (await _imgs.exists() == false)) {
    await _acv.create(recursive: true);
    await _imgs.create(recursive: true);

    /// Copy each .acv photoshop curve files to document directory.
    for (int i = 0; i < ACV_FILENAMES.length; i++) {
      try {
        final String filename = ACV_FILENAMES[i];
        final ByteData bytes = await rootBundle.load("assets/acv/${ACV_FILENAMES[i]}");
        await writeToFile(bytes, '$appDirectory/acv/$filename');
      } on Exception catch (e) {
        print(e);
        continue;
      }
    }

    final String filename = 'portrait.png';
    final ByteData bytes = await rootBundle.load("assets/img/$filename");
    await writeToFile(bytes, '$appDirectory/img/$filename');

    for (int i = 1; i < FFMPEG_FILTERS.length; i++) {
      await flutterFFmpeg.execute("-y -i $appDirectory/img/portrait.png ${FFMPEG_FILTERS[i]} $appDirectory/img/${FFMPEG_FILTER_NAMES[i].replaceAll(" ", "").toLowerCase()}.png");
    }
  }

  runApp(VideoEditorApp());
}

class VideoEditorApp extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
                        builder: (context) => CameraExampleHome(cameras: cameras),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Text("Browse from gallery"),
                    onPressed: () async {
                      PickedFile pickedFile = await _picker.getVideo(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        await initVideo(pickedFile.path);

                        originalVideoPath = pickedFile.path;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditVideoScreen(),
                          ),
                        );
                      } else {
                        print("No video file selected");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
