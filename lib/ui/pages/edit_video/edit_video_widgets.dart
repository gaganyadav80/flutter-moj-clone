import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:edverhub_video_editor/ui/pages/edit_video/edit_video_models.dart';
import 'package:edverhub_video_editor/ui/pages/edit_video/filters.dart';
import 'package:edverhub_video_editor/utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'edit_video_screen.dart';

class FiltersModalSheet extends StatefulWidget {
  const FiltersModalSheet({Key key, this.editVideoScreenState}) : super(key: key);

  final EditVideoScreenState editVideoScreenState;

  @override
  _FiltersModalSheetState createState() => _FiltersModalSheetState();
}

class _FiltersModalSheetState extends State<FiltersModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: FILTERS.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.editVideoScreenState.setState(() {
                // if (index == 0)
                currentFilterColor = FILTERS[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (index == 0)
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: CircleAvatar(
                            radius: 49.0,
                            backgroundColor: Colors.black,
                            child: Center(
                              child: Icon(
                                Icons.block_flipped,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: ColorFiltered(
                              colorFilter:
                                  FILTERS[index].filterMatrix == null ? ColorFilter.mode(FILTERS[index].filterColor, FILTERS[index].blendMode) : ColorFilter.matrix(FILTERS[index].filterMatrix),
                              child: Image.asset(
                                "assets/img/portrait.png",
                                fit: BoxFit.fitWidth,
                                height: 100.0,
                                width: 100.0,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 10.0),
                  Text(
                    FILTERS[index].filterName,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SoundModalSheet extends StatefulWidget {
  SoundModalSheet({Key key}) : super(key: key);

  // final AudioPlayer audioPlayer;
  // final ChewieController chewieController;

  @override
  State<StatefulWidget> createState() {
    return _SoundModalSheetState(); //create state
  }
}

class _SoundModalSheetState extends State<SoundModalSheet> {
  List<FileSystemEntity> _files;
  List<FileSystemEntity> _songs = [];
  String currentSongPath;
  final AudioPlayer player = AudioPlayer();

  void getFiles() {
    Directory dir = Directory('/storage/emulated/0/');
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.contains("Android") || path.contains("/.")) continue;
      if (path.contains("Call Recorder") || path.contains("call_recorder")) continue;
      if (path.contains("WhatsApp") || path.contains("Signal") || path.contains("Telegram")) continue;
      //TODO remove
      if (path.contains("MIUI")) continue;
      if (path.contains("PhoneRecord")) continue;

      bool isAudio = path.endsWith('.mp3') || path.endsWith('.wav') || path.endsWith('.aac') || path.endsWith('.m4a') || path.endsWith('.flac');
      isAudio = isAudio || path.endsWith('.MP3') || path.endsWith('.WAV') || path.endsWith('.AAC') || path.endsWith('.M4A') || path.endsWith('.FLAC');

      if (isAudio) _songs.add(entity);
    }
    print(_songs);
    print(_songs.length);
    setState(() {}); //update the UI
  }

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio from local storage"), backgroundColor: Colors.orange),
      body: _songs == null
          ? Center(child: Text("Searching Files"))
          : ListView.builder(
              itemCount: _songs?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_songs[index].path.split('/').last),
                  leading: Icon(Icons.audiotrack),
                  trailing: IconButton(
                    icon: player.playing && currentSongPath == _songs[index].path ? Icon(Icons.pause_outlined) : Icon(Icons.play_arrow),
                    color: Colors.orange,
                    onPressed: () async {
                      await player.setFilePath(_songs[index].path);

                      if (player.playing && currentSongPath == _songs[index].path)
                        player.pause();
                      else
                        player.play();

                      setState(() {
                        currentSongPath = _songs[index].path;
                      });
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Select this audio?"),
                        content: Text(_songs[index].path.split('/').last),
                        actions: [
                          FlatButton(
                            child: Text("No"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              // await widget.audioPlayer.setFilePath(_songs[index].path);
                              Navigator.pop(context);
                              Navigator.maybePop(context, _songs[index].path);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class TextModalSheet extends StatefulWidget {
  TextModalSheet({Key key, this.textController, this.editVideoScreenState}) : super(key: key);

  final TextEditingController textController;
  final EditVideoScreenState editVideoScreenState;

  @override
  _TextModalSheetState createState() => _TextModalSheetState();
}

class _TextModalSheetState extends State<TextModalSheet> {
  final FocusNode textNode = FocusNode();

  @override
  void dispose() {
    textNode.unfocus();
    textNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0),
              child: InkWell(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32.0,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.only(top: 40.0, right: 20.0),
              child: InkWell(
                child: Icon(
                  Icons.done_rounded,
                  color: Colors.white,
                  size: 32.0,
                ),
                onTap: () {
                  final UniqueKey textKey = UniqueKey();
                  textModelList.add(DraggableTextWidget(
                    textModel: TextModel(
                      widget.textController.text,
                      Offset(
                        widget.textController.text.length > 18
                            ? (MediaQuery.of(context).size.width / 4) - 45.0
                            : widget.textController.text.length > 10
                                ? (MediaQuery.of(context).size.width / 2) - 75.0
                                : (MediaQuery.of(context).size.width / 2) - 35.0,
                        (MediaQuery.of(context).size.height / 2) - 50.0,
                      ),
                    ),
                    key: textKey,
                    editVideoScreenState: widget.editVideoScreenState,
                  ));
                  // widget.editVideoScreenState.setState(() {

                  // });
                  Navigator.pop(context);
                  widget.textController.clear();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              constraints: BoxConstraints(maxHeight: 200.0),
              child: TextField(
                controller: widget.textController,
                focusNode: textNode,
                autofocus: true,
                style: TextStyle(color: Colors.white, fontSize: 32.0),
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                enableInteractiveSelection: true,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter text here...",
                  hintStyle: TextStyle(color: Colors.grey[800], fontSize: 32.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpeedModalSheet extends StatefulWidget {
  SpeedModalSheet({Key key, this.chewieController}) : super(key: key);

  final ChewieController chewieController;

  @override
  _SpeedModalSheetState createState() => _SpeedModalSheetState();
}

class _SpeedModalSheetState extends State<SpeedModalSheet> {
  final List<String> speedNotations = ["x1", "x0.2", "x0.5", "x1.5", "x2.0"];
  final List<String> speedNames = ["Normal", "Slower", "Slow", "Fast", "Faster"];

  @override
  Widget build(BuildContext context) {
    // [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
    // [1.0, 0.25, 0.5, 1.5, 2.0]

    return Container(
      height: 150.0,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.chewieController.playbackSpeeds.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.chewieController.videoPlayerController.setPlaybackSpeed(
                widget.chewieController.playbackSpeeds[index],
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.024),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 43,
                      backgroundColor: Colors.black,
                      child: Center(
                        child: Text(
                          speedNotations[index],
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    speedNames[index],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
