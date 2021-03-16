import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:edverhub_video_editor/ui/pages/edit_video/edit_video_models.dart';
import 'package:edverhub_video_editor/variables.dart';
import 'package:flutter/material.dart';

import 'edit_video_widgets.dart';

class EditVideoScreen extends StatefulWidget {
  EditVideoScreen({Key key}) : super(key: key);

  // final String videoPath;

  @override
  EditVideoScreenState createState() => EditVideoScreenState();
}

class EditVideoScreenState extends State<EditVideoScreen> with TickerProviderStateMixin {
  AnimationController _animationController;
  final TextEditingController textController = TextEditingController();
  // File audioFile;

  void _handleOnPressed() {
    setState(() {
      if (audioPlayer.playing)
        audioPlayer.pause();
      else
        audioPlayer.play();

      chewieController.togglePause();
      chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
    });
  }

  // void _awaitVideo() async {
  //   await initVideo(widget.videoPath);
  // }

  @override
  void initState() {
    super.initState();
    // _awaitVideo();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    chewieController.pause();
    chewieController.dispose();
    videoPlayerController.dispose();
    audioPlayer.stop();
    audioPlayer.dispose();
    //TODO flag
    // currentFilterColor = FILTERS[0];
    textController?.dispose();
    textModelList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          videoPlayerController.value.initialized
              ? Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Chewie(
                    controller: chewieController,
                  ),
                )
              : Container(),
          textModelList.isNotEmpty
              ? Stack(
                  children: textModelList
                      .map((model) => Positioned(
                            left: model.textModel.textOffset.dx,
                            top: model.textModel.textOffset.dy,
                            child: model,
                          ))
                      .toList(),
                )
              : SizedBox.shrink(),
          _buildBackButton(),
          _buildEffectsButtons(),
          _buildSpeedTextButtons(),
          _buildPlayPauseButton(),
          _buildNextButton(),
        ],
      ),
    );
  }

  Align _buildBackButton() => Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.only(top: 40.0, left: 20.0),
          child: InkWell(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 32.0,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
      );

  Align _buildPlayPauseButton() => Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          onTap: () => _handleOnPressed(),
          child: Container(
            width: 120.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(25.0)),
            ),
            margin: const EdgeInsets.only(bottom: 160.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  color: Colors.white,
                  size: 38.0,
                  progress: _animationController,
                ),
                SizedBox(width: 5.0),
                chewieController.isPlaying
                    ? Text("Pause", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white))
                    : Text("Play", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      );

  Align _buildNextButton() => Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.only(right: 10.0, bottom: 40.0),
          height: 40.0,
          width: 90.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            color: Colors.orange,
            child: Text("Next"),
            onPressed: () {
              print("Next pressed");
            },
          ),
        ),
      );

  Align _buildEffectsButtons() => Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: EdgeInsets.only(top: 50.0, right: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.movie_filter_outlined, size: 38.0, color: Colors.white),
                    Text("Filters", style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.black,
                  barrierColor: Colors.transparent,
                  builder: (context) => FiltersModalSheet(
                    editVideoScreenState: this,
                    // originalVideoPath: widget.videoPath,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.music_note_outlined, size: 38.0, color: Colors.white),
                    Text("Sound", style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () async {
                  if (chewieController.isPlaying) {
                    chewieController.pause();
                    audioPlayer.pause();
                  }
                  setState(() {
                    chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SoundModalSheet(),
                    ),
                  ).then((value) async {
                    print("VALUE ========= $value");

                    if (value != null) {
                      await audioPlayer.setFilePath(value);
                      await chewieController.setVolume(0.0);

                      if (audioPlayer.duration > chewieController.videoPlayerController.value.duration) {
                        await audioPlayer.setClip(start: Duration(seconds: 0), end: chewieController.videoPlayerController.value.duration);
                      }
                      await chewieController.seekTo(Duration(seconds: 0));
                      await audioPlayer.seek(Duration(seconds: 0));

                      setState(() {
                        chewieController.play();
                        audioPlayer.play();
                        chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
                      });
                    } else {
                      setState(() {
                        chewieController.play();
                        audioPlayer.play();
                        chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
                      });
                    }
                  });
                },
              ),
            ],
          ),
        ),
      );

  Align _buildSpeedTextButtons() => Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 30.0, left: 40.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.speed_outlined, size: 38.0, color: Colors.white),
                    Text("Speed", style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.black,
                  barrierColor: Colors.transparent,
                  builder: (context) => SpeedModalSheet(
                      // editVideoScreenState: this,
                      ),
                ),
              ),
              SizedBox(width: 40.0),
              InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.text_fields_outlined, size: 38.0, color: Colors.white),
                    Text("Text", style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () => showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  barrierColor: Colors.black.withOpacity(0.6),
                  builder: (BuildContext context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: TextModalSheet(
                      textController: textController,
                      editVideoScreenState: this,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
