import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:edverhub_video_editor/ui/pages/edit_video/edit_video_models.dart';
import 'package:edverhub_video_editor/ui/pages/edit_video/filters.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

import 'edit_video_widgets.dart';

class EditVideoScreen extends StatefulWidget {
  EditVideoScreen({Key key, this.video, this.chewieController, this.videoPlayerController, this.audioPlayer})
      : assert(video != null),
        assert(chewieController != null),
        assert(videoPlayerController != null),
        super(key: key);

  final File video;
  final VideoPlayerController videoPlayerController;
  final ChewieController chewieController;
  final AudioPlayer audioPlayer;

  @override
  EditVideoScreenState createState() => EditVideoScreenState();
}

class EditVideoScreenState extends State<EditVideoScreen> with TickerProviderStateMixin {
  AnimationController _animationController;
  // bool isPlaying = true;
  final TextEditingController textController = TextEditingController();
  File audioFile;

  void _handleOnPressed() {
    setState(() {
      if (widget.audioPlayer.playing)
        widget.audioPlayer.pause();
      else
        widget.audioPlayer.play();

      widget.chewieController.togglePause();
      // isPlaying = !isPlaying;
      widget.chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    widget.chewieController.pause();
    widget.chewieController.dispose();
    widget.videoPlayerController.dispose();
    widget.audioPlayer.stop();
    currentFilterColor = FILTERS[0];
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
          widget.videoPlayerController.value.initialized
              ? ColorFiltered(
                  colorFilter:
                      currentFilterColor.filterColor != null ? ColorFilter.mode(currentFilterColor.filterColor, currentFilterColor.blendMode) : ColorFilter.matrix(currentFilterColor.filterMatrix),
                  child: Container(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Chewie(
                      controller: widget.chewieController,
                    ),
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
                widget.chewieController.isPlaying
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
                  // showModalBottomSheet(
                  //   context: context,
                  //   backgroundColor: Colors.black,
                  //   barrierColor: Colors.transparent,
                  //   builder: (context) => SoundModalSheet(),
                  // );
                  ///
                  ///
                  ///
                  if (widget.chewieController.isPlaying) {
                    widget.chewieController.pause();
                    widget.audioPlayer.pause();
                  }
                  setState(() {
                    widget.chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SoundModalSheet(
                          // audioPlayer: widget.audioPlayer,
                          // chewieController: widget.chewieController,
                          ),
                    ),
                  ).then((value) async {
                    print("VALUE ========= $value");

                    if (value != null) {
                      await widget.audioPlayer.setFilePath(value);
                      await widget.chewieController.setVolume(0.0);

                      if (widget.audioPlayer.duration > widget.chewieController.videoPlayerController.value.duration) {
                        await widget.audioPlayer.setClip(start: Duration(seconds: 0), end: widget.chewieController.videoPlayerController.value.duration);
                      }
                      await widget.chewieController.seekTo(Duration(seconds: 0));
                      await widget.audioPlayer.seek(Duration(seconds: 0));

                      setState(() {
                        widget.chewieController.play();
                        widget.audioPlayer.play();
                        widget.chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
                      });
                    } else {
                      setState(() {
                        widget.chewieController.play();
                        widget.audioPlayer.play();
                        widget.chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
                      });
                    }
                  });

                  // FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.audio);

                  // if (result != null) {
                  //   audioFile = File(result.files.single.path);
                  //   await widget.chewieController.setVolume(0.0);
                  //   print(audioFile.path);

                  //   await widget.audioPlayer.setFilePath(audioFile.path);
                  //   if (widget.audioPlayer.duration > widget.chewieController.videoPlayerController.value.duration) {
                  //     await widget.audioPlayer.setClip(start: Duration(seconds: 0), end: widget.chewieController.videoPlayerController.value.duration);
                  //   }
                  //   await widget.chewieController.seekTo(Duration(seconds: 0));

                  //   setState(() {
                  //     widget.chewieController.play();
                  //     widget.audioPlayer.play();
                  //     widget.chewieController.isPlaying ? _animationController.reverse() : _animationController.forward();
                  //   });
                  // } else {
                  //   print("Audio pick cancled");
                  // }
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
                    chewieController: widget.chewieController,
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
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
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
