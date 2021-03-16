import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController videoPlayerController;
ChewieController chewieController;
final AudioPlayer audioPlayer = AudioPlayer();
final FlutterFFmpeg flutterFFmpeg = new FlutterFFmpeg();

String appDirectory;
String originalVideoPath;

List<CameraDescription> cameras = [];

//write to app path
Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

Future<void> initVideo(String _videoPath) async {
  videoPlayerController = VideoPlayerController.file(File(_videoPath), videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
  await videoPlayerController.initialize().then((value) {
    videoPlayerController.addListener(() async {
      if (videoPlayerController.value.position == videoPlayerController.value.duration) {
        await videoPlayerController.seekTo(Duration(seconds: 0));
        await audioPlayer.seek(Duration(seconds: 0));
        videoPlayerController.play();
        audioPlayer.play();
        print('audio played');
      }
    });
  });

  chewieController = ChewieController(
    videoPlayerController: videoPlayerController,
    playbackSpeeds: [1.0, 0.25, 0.5, 1.5, 2.0],
    showControls: false,
    allowedScreenSleep: false,
    autoPlay: true,
    looping: false,
  );
}
