// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   const CameraScreen({Key key, this.cameras}) : super(key: key);

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
//   Timer _timer;
//   int videoSpeed = 1;
//   List<List<int>> _totalAndLastTime = [];
//   //trimtimes - starttime, endtime
//   List<List<int>> trimtimes = [];
//   int _lasttime = 0;
//   int _totalTimeInSeconds = 0;

//   CameraController controller;
//   XFile videoFile;
//   VideoPlayerController videoController;
//   VoidCallback videoPlayerListener;
//   bool enableAudio = true;
//   // ignore: unused_field
//   double _minAvailableExposureOffset = 0.0;
//   // ignore: unused_field
//   double _maxAvailableExposureOffset = 0.0;
//   // ignore: unused_field
//   double _currentExposureOffset = 0.0;
//   AnimationController _flashModeControlRowAnimationController;
//   Animation<double> _flashModeControlRowAnimation;
//   AnimationController _exposureModeControlRowAnimationController;
//   // ignore: unused_field
//   Animation<double> _exposureModeControlRowAnimation;
//   AnimationController _focusModeControlRowAnimationController;
//   // ignore: unused_field
//   Animation<double> _focusModeControlRowAnimation;
//   double _minAvailableZoom;
//   double _maxAvailableZoom;
//   double _currentScale = 1.0;
//   double _baseScale = 1.0;
//   List<CameraDescription> cameras;
//   int _cameraMode = 0;

//   Color iconsColor = Colors.white;
//   // Counting pointers (number of user fingers on screen)
//   int _pointers = 0;
//   // ignore: unused_field
//   Future<void> _future;
//   double iconSize = 30;
//   @override
//   void initState() {
//     super.initState();

//     cameras = widget.cameras;
//     controller = CameraController(
//       cameras[0],
//       ResolutionPreset.veryHigh,
//       enableAudio: enableAudio,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );
//     _cameraMode = 0;
//     _future = onNewCameraSelected(0);
//     // _future = controller.setFocusMode(FocusMode.auto);
//     WidgetsBinding.instance.addObserver(this);
//     _flashModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _flashModeControlRowAnimation = CurvedAnimation(
//       parent: _flashModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//     _exposureModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _exposureModeControlRowAnimation = CurvedAnimation(
//       parent: _exposureModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//     _focusModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _focusModeControlRowAnimation = CurvedAnimation(
//       parent: _focusModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//   }

//   _startTimer() {
//     _totalAndLastTime.add([_totalTimeInSeconds, _lasttime]);
//     _lasttime = 0;
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_totalTimeInSeconds <= 30) {
//           _lasttime++;
//           _totalTimeInSeconds++;
//         } else {
//           setState(() {
//             onStopButtonPressed();
//           });
//         }
//       });
//     });
//   }

//   // @override
//   // void dispose() {
//   //   WidgetsBinding.instance.removeObserver(this);
//   //   _flashModeControlRowAnimationController.dispose();
//   //   _exposureModeControlRowAnimationController.dispose();
//   //   super.dispose();
//   // }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // App state changed before we got the chance to initialize.
//     if (controller == null || !controller.value.isInitialized) {
//       return;
//     }
//     if (state == AppLifecycleState.inactive) {
//       controller?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       if (controller != null) {
//         onNewCameraSelected(_cameraMode);
//       }
//     }
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   Widget _cameraPreviewWidget() {
//     if (controller == null || !controller.value.isInitialized) {
//       return Center(
//         child: Text(
//           'Tap a camera',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24.0,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//       );
//     } else {
//       return Listener(
//         onPointerDown: (_) => _pointers++,
//         onPointerUp: (_) => _pointers--,
//         child: CameraPreview(
//           controller,
//           child: LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//               return GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onScaleStart: _handleScaleStart,
//                 onScaleUpdate: _handleScaleUpdate,
//                 // onTapDown: (details) => onViewFinderTap(details, constraints),
//               );
//             },
//           ),
//         ),
//       );
//     }
//   }

//   void _handleScaleStart(ScaleStartDetails details) {
//     _baseScale = _currentScale;
//   }

//   Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
//     // When there are not exactly two fingers on screen don't scale
//     if (_pointers != 2) {
//       return;
//     }

//     _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);

//     await controller.setZoomLevel(_currentScale);
//   }

//   /// Display the thumbnail of the captured image or video.
//   // Widget _thumbnailWidget() {
//   //   return Align(
//   //     alignment: Alignment.centerRight,
//   //     child: Row(
//   //       mainAxisSize: MainAxisSize.min,
//   //       children: <Widget>[
//   //         //TODO: change
//   //         videoController == null && imageFile == null
//   //             ? Container()
//   //             : SizedBox(
//   //                 child: (videoController == null)
//   //                     ? Image.file(File(imageFile.path))
//   //                     : Container(
//   //                         child: Center(
//   //                           child: AspectRatio(
//   //                             aspectRatio: videoController.value.size != null ? videoController.value.aspectRatio : 1.0,
//   //                             child: VideoPlayer(
//   //                               videoController,
//   //                             ),
//   //                           ),
//   //                         ),
//   //                         decoration: BoxDecoration(border: Border.all(color: Colors.pink)),
//   //                       ),
//   //                 width: 64.0,
//   //                 height: 64.0,
//   //               ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _flashModeControlRowWidget() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SizeTransition(
//         sizeFactor: _flashModeControlRowAnimation,
//         child: ClipRect(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_off,
//                   size: iconSize,
//                 ),
//                 color: controller?.value?.flashMode == FlashMode.off ? Colors.orange : Colors.white,
//                 onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.off) : null,
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_auto,
//                   size: iconSize,
//                 ),
//                 color: controller?.value?.flashMode == FlashMode.auto ? Colors.orange : Colors.white,
//                 onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.auto) : null,
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_on,
//                   size: iconSize,
//                 ),
//                 color: controller?.value?.flashMode == FlashMode.always ? Colors.orange : Colors.white,
//                 onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.always) : null,
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.highlight,
//                   size: iconSize,
//                 ),
//                 color: controller?.value?.flashMode == FlashMode.torch ? Colors.orange : Colors.white,
//                 onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.torch) : null,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

//   void showInSnackBar(String message) {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   // void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
//   //   final offset = Offset(
//   //     details.localPosition.dx / constraints.maxWidth,
//   //     details.localPosition.dy / constraints.maxHeight,
//   //   );
//   //   controller.setExposurePoint(offset);
//   //   controller.setFocusPoint(offset);
//   // }

//   Future<void> onNewCameraSelected(int cameradesc) async {
//     if (controller != null) {
//       await controller.dispose();
//     }

//     controller = CameraController(
//       cameras[cameradesc],
//       ResolutionPreset.medium,
//       enableAudio: enableAudio,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );

//     // If the controller is updated then update the UI.
//     controller.addListener(() {
//       if (mounted) setState(() {});
//       if (controller.value.hasError) {
//         showInSnackBar('Camera error ${controller.value.errorDescription}');
//       }
//     });

//     try {
//       await controller.initialize();
//       await Future.wait([
//         controller.getMinExposureOffset().then((value) => _minAvailableExposureOffset = value),
//         controller.getMaxExposureOffset().then((value) => _maxAvailableExposureOffset = value),
//         controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
//         controller.getMinZoomLevel().then((value) => _minAvailableZoom = value),
//       ]);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> onFlashModeButtonPressed() {
//     if (_flashModeControlRowAnimationController.value == 1) {
//       _flashModeControlRowAnimationController.reverse();
//     } else {
//       _flashModeControlRowAnimationController.forward();
//       _exposureModeControlRowAnimationController.reverse();
//       _focusModeControlRowAnimationController.reverse();
//     }
//   }

//   Future<void> onExposureModeButtonPressed() {
//     if (_exposureModeControlRowAnimationController.value == 1) {
//       _exposureModeControlRowAnimationController.reverse();
//     } else {
//       _exposureModeControlRowAnimationController.forward();
//       _flashModeControlRowAnimationController.reverse();
//       _focusModeControlRowAnimationController.reverse();
//     }
//   }

//   Future<void> onAudioModeButtonPressed() async {
//     enableAudio = !enableAudio;
//     if (controller != null) {
//       await onNewCameraSelected(_cameraMode);
//     }
//   }

//   Future<void> onSetFlashModeButtonPressed(FlashMode mode) async {
//     await setFlashMode(mode).then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
//     });
//   }

//   Future<void> onSetExposureModeButtonPressed(ExposureMode mode) async {
//     await setExposureMode(mode).then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
//     });
//   }

//   Future<void> onVideoRecordButtonPressed() async {
//     _startTimer();
//     await startVideoRecording().then((_) {
//       if (mounted) setState(() {});
//     });
//   }

//   Future<void> onStopButtonPressed() async {
//     _timer.cancel();
//     await stopVideoRecording().then((file) {
//       if (mounted)
//         setState(() {
//           _lasttime = 0;
//         });
//       if (file != null) {
//         showInSnackBar('Video recorded to ${file.path}');
//         videoFile = file;
//         // _startVideoPlayer();
//       }
//     });
//   }

//   Future<void> onPauseButtonPressed() async {
//     _timer.cancel();
//     await pauseVideoRecording().then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Video recording paused');
//     });
//   }

//   Future<void> onResumeButtonPressed() async {
//     await resumeVideoRecording().then((_) {
//       _startTimer();
//       if (mounted) setState(() {});
//       showInSnackBar('Video recording resumed');
//     });
//   }

//   Future<void> startVideoRecording() async {
//     if (!controller.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return;
//     }

//     if (controller.value.isRecordingVideo) {
//       // A recording is already started, do nothing.
//       return;
//     }

//     try {
//       await controller.startVideoRecording().then((value) => setState(() {}));
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return;
//     }
//   }

//   Future<XFile> stopVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       return await controller.stopVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }

//   Future<void> pauseVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       await controller.pauseVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> resumeVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       await controller.resumeVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setFlashMode(FlashMode mode) async {
//     try {
//       await controller.setFlashMode(mode);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setExposureMode(ExposureMode mode) async {
//     try {
//       await controller.setExposureMode(mode);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setExposureOffset(double offset) async {
//     setState(() {
//       _currentExposureOffset = offset;
//     });
//     try {
//       offset = await controller.setExposureOffset(offset);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       } else {
//         return false;
//       }
//     }
//   }

//   Future<void> startPauseButton() async {
//     return controller != null && controller.value.isInitialized && !controller.value.isRecordingVideo
//         ? await onVideoRecordButtonPressed()
//         : (controller.value.isRecordingPaused)
//             ? _totalTimeInSeconds < 30
//                 ? onResumeButtonPressed()
//                 : showInSnackBar('30 seconds Completed')
//             : onPauseButtonPressed();
//   }

//   Future<void> changeCameraMode() async {
//     if (_cameraMode == 0)
//       _cameraMode = 1;
//     else
//       _cameraMode = 0;
//     setState(() async {
//       await onNewCameraSelected(_cameraMode);
//     });
//   }

//   void deleteLastClip() {
//     if (controller != null && controller.value.isInitialized && controller.value.isRecordingVideo) {
//       if (controller.value.isRecordingPaused) {
//         if (_totalTimeInSeconds == 0) {
//           showInSnackBar('No clip to delete');
//         } else {
//           trimtimes.add([_totalTimeInSeconds - _lasttime, _totalTimeInSeconds]);
//           _totalTimeInSeconds = _totalTimeInSeconds - _lasttime;
//           _lasttime = _totalAndLastTime[_totalAndLastTime.length - 1][1];
//           showInSnackBar('Clip deleted');
//         }
//       } else {
//         showInSnackBar('You have to stop the video');
//       }
//     } else {
//       showInSnackBar('You haven\'t recorded any clip yet');
//     }
//   }

//   Future<void> saveAndProceed() async {
//     await onStopButtonPressed();
//     try {
//       //TODO: delete clips and change speed
//       // File _video = File(videoFile.path);
//       String path = videoFile.path;
//       final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
//       String startTime = "00:00:00";
//       String endTime = "00:00:00";
//       if (Platform.isAndroid) {
//         if (await _requestPermission(Permission.storage)) {
//           Directory directory;
//           directory = await getExternalStorageDirectory();
//           print(directory.path);
//           String newPath = "";
//           List<String> folders = directory.path.split("/");
//           for (var x = 0; x < folders.length; x++) {
//             String folder = folders[x];
//             if (folder != "Android") {
//               newPath += "/" + folder;
//             } else {
//               break;
//             }
//           }
//           newPath = newPath + "/EdverhubVideo";
//           directory = Directory(newPath);
//           if (!await directory.exists()) {
//             await directory.create(recursive: true);
//           }
//           if (await directory.exists()) {
//             String curDate = DateTime.now().toString();
//             // File savedfile = File(directory.path + "/VIDEO-$curDate.mp4");
//             String endPath = directory.path + "/VDkjsdjbfdsjbfE.mp4";
//             for (int i = trimtimes.length - 1; i >= 0; i--) {
//               if (trimtimes[i][0] / 10 == 0) {
//                 startTime = "00:00:0${trimtimes[i][0]}";
//               } else {
//                 startTime = "00:00:${trimtimes[i][0]}";
//               }
//               if (trimtimes[i][1] / 10 == 0) {
//                 endTime = "00:00:0${trimtimes[i][1]}";
//               } else {
//                 endTime = "00:00:${trimtimes[i][1]}";
//               }
//               logger.i('DELETING AT: $startTime and $endTime');
//               int x = await _flutterFFmpeg.execute("-i $path -ss $startTime -to $endTime -async 1 -c copy $endPath");

//               if (x == 0) {
//                 logger.i("FFMPEG: Successful");
//               } else if (x == 255) {
//                 logger.i("FFMPEG: User Cancel");
//               } else {
//                 logger.i("FFMPEG: Something Else");
//               }
//             }
//           }
//         }
//       } else {}

//       // await GallerySaver.saveVideo(
//       //   videoFile.path,
//       //   albumName: 'Edverhub Video',
//       // ).then((value) => logger.w("Gallery Saver: $value"));
//       // Navigator.of(context).push(
//       //   MaterialPageRoute(builder: (BuildContext context) {
//       //     return EditVideoScreen(
//       //       video: _video,
//       //       // videoPlayerController: ,
//       //     );
//       //   }),
//       // );
//     } catch (e) {
//       logger.wtf('Camera Screen Error: $e');
//     }
//     logger.wtf('Camera Screen Success');
//     trimtimes = [];
//     _totalTimeInSeconds = 0;
//     _lasttime = 0;
//   }
//   // Future<void> _startVideoPlayer() async {
//   //   final VideoPlayerController vController = VideoPlayerController.file(File(videoFile.path));
//   //   videoPlayerListener = () {
//   //     if (videoController != null && videoController.value.size != null) {
//   //       // Refreshing the state to update video player with the correct ratio.
//   //       if (mounted) setState(() {});
//   //       videoController.removeListener(videoPlayerListener);
//   //     }
//   //   };
//   //   vController.addListener(videoPlayerListener);
//   //   await vController.setLooping(true);
//   //   await vController.initialize();
//   //   await videoController?.dispose();
//   //   if (mounted) {
//   //     setState(() {
//   //       imageFile = null;
//   //       videoController = vController;
//   //     });
//   //   }
//   //   await vController.play();
//   // }

//   void _showCameraException(CameraException e) {
//     logError(e.code, e.description);
//     showInSnackBar('Error: ${e.code}\n${e.description}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       key: _scaffoldKey,
//       body: Stack(
//         children: [
//           cameraWidget(),
//           bottomBar(),
//           moreOptions(),
//           recordButton(context),
//           progressIndicator(),
//         ],
//       ),
//     );
//   }

//   Column cameraWidget() {
//     return Column(
//       children: <Widget>[
//         Center(
//           //TODO: Resolve this- gives error before showing the camera screen
//           child: Transform.scale(
//             scale: controller.value.aspectRatio,
//             child: _cameraPreviewWidget(),
//           ),
//         ),
//       ],
//     );
//   }

//   Padding progressIndicator() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       child: LinearProgressIndicator(
//         backgroundColor: iconsColor,
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//         value: ((_totalTimeInSeconds) / 30).toDouble(),
//       ),
//     );
//   }

//   Align recordButton(BuildContext context) {
//     return Align(
//       alignment: Alignment.topLeft,
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: IconButton(
//           icon: Icon(
//             Icons.cancel_outlined,
//             size: iconSize,
//           ),
//           color: iconsColor,
//           onPressed: () async {
//             print('cancel pressed');
//             // if (controller != null && controller.value.isInitialized) {
//             //   if (controller.value.isRecordingVideo) {
//             //     return await onStopButtonPressed();
//             //   }
//             //   if (controller.value.isRecordingPaused) {
//             //     return await onStopButtonPressed();
//             //   }
//             // }
//             await controller.dispose();
//             _timer.cancel();
//             trimtimes = [];
//             _totalTimeInSeconds = 0;
//             _lasttime = 0;
//             _totalAndLastTime = [];
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//     );
//   }

//   Padding bottomBar() {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 40),
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: startPauseButton,
//                   child: CircleAvatar(
//                     radius: 30,
//                     backgroundColor: controller.value.isRecordingVideo && !controller.value.isRecordingPaused ? Colors.white : Colors.orange,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.flip_camera_android_outlined,
//                     color: Colors.white,
//                     size: iconSize,
//                   ),
//                   onPressed: changeCameraMode,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Align moreOptions() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.cancel_presentation_outlined,
//                   size: iconSize,
//                 ),
//                 color: iconsColor,
//                 onPressed: deleteLastClip,
//               ),
//               IconButton(
//                 icon: Icon(
//                   enableAudio ? Icons.volume_up : Icons.volume_off,
//                   size: iconSize,
//                 ),
//                 color: iconsColor,
//                 onPressed: () async {
//                   return controller != null ? onAudioModeButtonPressed : null;
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_on,
//                   size: iconSize,
//                 ),
//                 color: iconsColor,
//                 onPressed: controller != null ? onFlashModeButtonPressed : null,
//               ),
//               _flashModeControlRowWidget(),
//               IconButton(
//                 icon: Icon(
//                   Icons.done,
//                   size: iconSize,
//                 ),
//                 color: iconsColor,
//                 onPressed: saveAndProceed,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

// class CameraScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   const CameraScreen({Key key, this.cameras}) : super(key: key);

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
//   Timer _timer;
//   int videoSpeed = 1;
//   List<List<int>> _totalAndLastTime = [];
//   //trimtimes - starttime, endtime
//   // List<List<int>> trimtimes = [];
//   int _lasttime = 0;
//   int _totalTimeInSeconds = 0;

//   CameraController controller;
//   XFile videoFile;
//   VideoPlayerController videoController;
//   VoidCallback videoPlayerListener;
//   bool enableAudio = true;
//   // ignore: unused_field
//   double _minAvailableExposureOffset = 0.0;
//   // ignore: unused_field
//   double _maxAvailableExposureOffset = 0.0;
//   // ignore: unused_field
//   double _currentExposureOffset = 0.0;
//   AnimationController _flashModeControlRowAnimationController;
//   Animation<double> _flashModeControlRowAnimation;
//   AnimationController _exposureModeControlRowAnimationController;
//   // ignore: unused_field
//   Animation<double> _exposureModeControlRowAnimation;
//   AnimationController _focusModeControlRowAnimationController;
//   // ignore: unused_field
//   Animation<double> _focusModeControlRowAnimation;
//   double _minAvailableZoom;
//   double _maxAvailableZoom;
//   double _currentScale = 1.0;
//   double _baseScale = 1.0;
//   List<CameraDescription> cameras;
//   int _cameraMode = 0;

//   Color iconsColor = Colors.white;
//   // Counting pointers (number of user fingers on screen)
//   int _pointers = 0;
//   // ignore: unused_field
//   Future<void> _future;
//   double iconSize = 30;
//   @override
//   void initState() {
//     super.initState();

//     cameras = widget.cameras;
//     controller = CameraController(
//       cameras[0],
//       ResolutionPreset.veryHigh,
//       enableAudio: enableAudio,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );
//     _cameraMode = 0;
//     _future = onNewCameraSelected(0);
//     // _future = controller.setFocusMode(FocusMode.auto);
//     WidgetsBinding.instance.addObserver(this);
//     _flashModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _flashModeControlRowAnimation = CurvedAnimation(
//       parent: _flashModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//     _exposureModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _exposureModeControlRowAnimation = CurvedAnimation(
//       parent: _exposureModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//     _focusModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _focusModeControlRowAnimation = CurvedAnimation(
//       parent: _focusModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//   }

//   _startTimer() {
//     _lasttime = 0;
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_totalTimeInSeconds <= 30) {
//           _lasttime++;
//           _totalTimeInSeconds++;
//         } else {
//           setState(() {
//             onStopButtonPressed();
//           });
//         }
//       });
//     });
//   }

//   // @override
//   // void dispose() {
//   //   WidgetsBinding.instance.removeObserver(this);
//   //   _flashModeControlRowAnimationController.dispose();
//   //   _exposureModeControlRowAnimationController.dispose();
//   //   super.dispose();
//   // }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // App state changed before we got the chance to initialize.
//     if (controller == null || !controller.value.isInitialized) {
//       return;
//     }
//     if (state == AppLifecycleState.inactive) {
//       controller?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       if (controller != null) {
//         onNewCameraSelected(_cameraMode);
//       }
//     }
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   Widget _cameraPreviewWidget() {
//     if (controller == null || !controller.value.isInitialized) {
//       return Center(
//         child: Text(
//           'Tap a camera',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24.0,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//       );
//     } else {
//       return Listener(
//         onPointerDown: (_) => _pointers++,
//         onPointerUp: (_) => _pointers--,
//         child: CameraPreview(
//           controller,
//           child: LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//               return GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onScaleStart: _handleScaleStart,
//                 onScaleUpdate: _handleScaleUpdate,
//                 // onTapDown: (details) => onViewFinderTap(details, constraints),
//               );
//             },
//           ),
//         ),
//       );
//     }
//   }

//   void _handleScaleStart(ScaleStartDetails details) {
//     _baseScale = _currentScale;
//   }

//   Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
//     // When there are not exactly two fingers on screen don't scale
//     if (_pointers != 2) {
//       return;
//     }

//     _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);

//     await controller.setZoomLevel(_currentScale);
//   }

//   /// Display the thumbnail of the captured image or video.
//   // Widget _thumbnailWidget() {
//   //   return Align(
//   //     alignment: Alignment.centerRight,
//   //     child: Row(
//   //       mainAxisSize: MainAxisSize.min,
//   //       children: <Widget>[
//   //         //TODO: change
//   //         videoController == null && imageFile == null
//   //             ? Container()
//   //             : SizedBox(
//   //                 child: (videoController == null)
//   //                     ? Image.file(File(imageFile.path))
//   //                     : Container(
//   //                         child: Center(
//   //                           child: AspectRatio(
//   //                             aspectRatio: videoController.value.size != null ? videoController.value.aspectRatio : 1.0,
//   //                             child: VideoPlayer(
//   //                               videoController,
//   //                             ),
//   //                           ),
//   //                         ),
//   //                         decoration: BoxDecoration(border: Border.all(color: Colors.pink)),
//   //                       ),
//   //                 width: 64.0,
//   //                 height: 64.0,
//   //               ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _flashModeControlRowWidget() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SizeTransition(
//         sizeFactor: _flashModeControlRowAnimation,
//         child: ClipRect(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_off,
//                   size: iconSize,
//                 ),
//                 color: controller?.value?.flashMode == FlashMode.off ? Colors.orange : Colors.white,
//                 onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.off) : null,
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_auto,
//                   size: iconSize,
//                 ),
//                 color: controller?.value?.flashMode == FlashMode.auto ? Colors.orange : Colors.white,
//                 onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.auto) : null,
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_on,
//                   size: iconSize,
//                 ),
//                 color: controller?.value?.flashMode == FlashMode.always ? Colors.orange : Colors.white,
//                 onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.always) : null,
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.highlight,
//                   size: iconSize,
//                 ),
//                 color: controller?.value?.flashMode == FlashMode.torch ? Colors.orange : Colors.white,
//                 onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.torch) : null,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

//   void showInSnackBar(String message) {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   // void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
//   //   final offset = Offset(
//   //     details.localPosition.dx / constraints.maxWidth,
//   //     details.localPosition.dy / constraints.maxHeight,
//   //   );
//   //   controller.setExposurePoint(offset);
//   //   controller.setFocusPoint(offset);
//   // }

//   Future<void> onNewCameraSelected(int cameradesc) async {
//     if (controller != null) {
//       await controller.dispose();
//     }

//     controller = CameraController(
//       cameras[cameradesc],
//       ResolutionPreset.medium,
//       enableAudio: enableAudio,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );

//     // If the controller is updated then update the UI.
//     controller.addListener(() {
//       if (mounted) setState(() {});
//       if (controller.value.hasError) {
//         showInSnackBar('Camera error ${controller.value.errorDescription}');
//       }
//     });

//     try {
//       await controller.initialize();
//       await Future.wait([
//         controller.getMinExposureOffset().then((value) => _minAvailableExposureOffset = value),
//         controller.getMaxExposureOffset().then((value) => _maxAvailableExposureOffset = value),
//         controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
//         controller.getMinZoomLevel().then((value) => _minAvailableZoom = value),
//       ]);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> onFlashModeButtonPressed() {
//     if (_flashModeControlRowAnimationController.value == 1) {
//       _flashModeControlRowAnimationController.reverse();
//     } else {
//       _flashModeControlRowAnimationController.forward();
//       _exposureModeControlRowAnimationController.reverse();
//       _focusModeControlRowAnimationController.reverse();
//     }
//   }

//   Future<void> onExposureModeButtonPressed() {
//     if (_exposureModeControlRowAnimationController.value == 1) {
//       _exposureModeControlRowAnimationController.reverse();
//     } else {
//       _exposureModeControlRowAnimationController.forward();
//       _flashModeControlRowAnimationController.reverse();
//       _focusModeControlRowAnimationController.reverse();
//     }
//   }

//   Future<void> onAudioModeButtonPressed() async {
//     enableAudio = !enableAudio;
//     if (controller != null) {
//       await onNewCameraSelected(_cameraMode);
//     }
//   }

//   Future<void> onSetFlashModeButtonPressed(FlashMode mode) async {
//     await setFlashMode(mode).then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
//     });
//   }

//   Future<void> onSetExposureModeButtonPressed(ExposureMode mode) async {
//     await setExposureMode(mode).then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
//     });
//   }

//   Future<void> onVideoRecordButtonPressed() async {
//     _startTimer();
//     await startVideoRecording().then((_) {
//       if (mounted) setState(() {});
//     });
//   }

//   Future<void> onStopButtonPressed() async {
//     _timer.cancel();
//     await stopVideoRecording().then((file) {
//       if (mounted)
//         setState(() {
//           _lasttime = 0;
//         });
//       if (file != null) {
//         showInSnackBar('Video recorded to ${file.path}');
//         videoFile = file;
//         // _startVideoPlayer();
//       }
//     });
//   }

//   Future<void> onPauseButtonPressed() async {
//     _totalAndLastTime.add([_totalTimeInSeconds, _lasttime]);
//     _timer.cancel();
//     await pauseVideoRecording().then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Video recording paused');
//     });
//   }

//   Future<void> onResumeButtonPressed() async {
//     await resumeVideoRecording().then((_) {
//       _startTimer();
//       if (mounted) setState(() {});
//       showInSnackBar('Video recording resumed');
//     });
//   }

//   Future<void> startVideoRecording() async {
//     if (!controller.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return;
//     }

//     if (controller.value.isRecordingVideo) {
//       // A recording is already started, do nothing.
//       return;
//     }

//     try {
//       await controller.startVideoRecording().then((value) => setState(() {}));
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return;
//     }
//   }

//   Future<XFile> stopVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       return await controller.stopVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }

//   Future<void> pauseVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       await controller.pauseVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> resumeVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       await controller.resumeVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setFlashMode(FlashMode mode) async {
//     try {
//       await controller.setFlashMode(mode);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setExposureMode(ExposureMode mode) async {
//     try {
//       await controller.setExposureMode(mode);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setExposureOffset(double offset) async {
//     setState(() {
//       _currentExposureOffset = offset;
//     });
//     try {
//       offset = await controller.setExposureOffset(offset);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       } else {
//         return false;
//       }
//     }
//   }

//   Future<void> startPauseButton() async {
//     return controller != null && controller.value.isInitialized && !controller.value.isRecordingVideo
//         ? await onVideoRecordButtonPressed()
//         : (controller.value.isRecordingPaused)
//             ? _totalTimeInSeconds < 30
//                 ? onResumeButtonPressed()
//                 : showInSnackBar('30 seconds Completed')
//             : onPauseButtonPressed();
//   }

//   Future<void> changeCameraMode() async {
//     if (_cameraMode == 0)
//       _cameraMode = 1;
//     else
//       _cameraMode = 0;
//     setState(() async {
//       await onNewCameraSelected(_cameraMode);
//     });
//   }

//   void deleteLastClip() {
//     if (controller != null && controller.value.isInitialized && controller.value.isRecordingVideo) {
//       if (controller.value.isRecordingPaused) {
//         if (_totalTimeInSeconds == 0) {
//           showInSnackBar('No clip to delete');
//         } else {
//           _totalAndLastTime.removeLast();
//           // trimtimes.add([_totalTimeInSeconds - _lasttime, _totalTimeInSeconds]);
//           _totalTimeInSeconds = _totalTimeInSeconds - _lasttime;
//           _lasttime = _totalAndLastTime[_totalAndLastTime.length - 1][1];
//           showInSnackBar('Clip deleted');
//         }
//       } else {
//         showInSnackBar('You have to stop the video');
//       }
//     } else {
//       showInSnackBar('You haven\'t recorded any clip yet');
//     }
//   }

//   Future<void> saveAndProceed() async {
//     await onStopButtonPressed();
//     try {
//       //TODO: delete clips and change speed
//       // File _video = File(videoFile.path);
//       String path = videoFile.path;
//       final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
//       String startTime = "00:00:00";
//       String endTime = "00:00:00";
//       if (Platform.isAndroid) {
//         if (await _requestPermission(Permission.storage)) {
//           Directory directory;
//           directory = await getExternalStorageDirectory();
//           print(directory.path);
//           String newPath = "";
//           List<String> folders = directory.path.split("/");
//           for (var x = 0; x < folders.length; x++) {
//             String folder = folders[x];
//             if (folder != "Android") {
//               newPath += "/" + folder;
//             } else {
//               break;
//             }
//           }
//           newPath = newPath + "/EdverhubVideo";
//           directory = Directory(newPath);
//           if (!await directory.exists()) {
//             await directory.create(recursive: true);
//           }
//           if (await directory.exists()) {
//             String curDate = DateTime.now().toString();
//             // File savedfile = File(directory.path + "/VIDEO-$curDate.mp4");
//             String endPath = directory.path + "/VID";
//             String text = "";
//             File file = File(directory.path + "/inputs.txt");
//             for (int i = 0; i < _totalAndLastTime.length; i++) {
//               if (_totalAndLastTime[i][0] % 10 == 0) {
//                 startTime = "00:00:0${_totalAndLastTime[i][0]}";
//               } else {
//                 startTime = "00:00:${_totalAndLastTime[i][0]}";
//               }
//               if (_totalAndLastTime[i][1] % 10 == 0) {
//                 endTime = "00:00:0${_totalAndLastTime[i][1]}";
//               } else {
//                 endTime = "00:00:${_totalAndLastTime[i][1]}";
//               }
//               logger.i('COPYING AT: $startTime and $endTime');

//               int x = await _flutterFFmpeg.execute("-i $path -ss $startTime -to $endTime -async 1 -c copy $endPath$i.mp4");
//               text += "file \'$endPath$i.mp4\n\'";
//               if (x == 0) {
//                 logger.i("FFMPEG$i: Successful");
//               } else if (x == 255) {
//                 logger.i("FFMPEG$i: User Cancel");
//               } else {
//                 logger.i("FFMPEG$i: Something Else");
//               }
//             }
//             int x;
//             try {
//               await file.writeAsString(text);
//               x = await _flutterFFmpeg.execute("-f concat -i ${file.path} -c copy $endPath.mp4");
//             } catch (e) {
//               logger.wtf('ERROR');
//             }
//             if (x == 0) {
//               logger.i("FFMPEG: Successful");
//             } else if (x == 255) {
//               logger.i("FFMPEG: User Cancel");
//             } else {
//               logger.i("FFMPEG: Something Else");
//             }
//           }
//         }
//       } else {}

//       // await GallerySaver.saveVideo(
//       //   videoFile.path,
//       //   albumName: 'Edverhub Video',
//       // ).then((value) => logger.w("Gallery Saver: $value"));
//       // Navigator.of(context).push(
//       //   MaterialPageRoute(builder: (BuildContext context) {
//       //     return EditVideoScreen(
//       //       video: _video,
//       //       // videoPlayerController: ,
//       //     );
//       //   }),
//       // );
//     } catch (e) {
//       logger.wtf('Camera Screen Error: $e');
//     }
//     logger.wtf('Camera Screen Success');
//     // trimtimes = [];
//     _totalTimeInSeconds = 0;
//     _lasttime = 0;
//   }
//   // Future<void> _startVideoPlayer() async {
//   //   final VideoPlayerController vController = VideoPlayerController.file(File(videoFile.path));
//   //   videoPlayerListener = () {
//   //     if (videoController != null && videoController.value.size != null) {
//   //       // Refreshing the state to update video player with the correct ratio.
//   //       if (mounted) setState(() {});
//   //       videoController.removeListener(videoPlayerListener);
//   //     }
//   //   };
//   //   vController.addListener(videoPlayerListener);
//   //   await vController.setLooping(true);
//   //   await vController.initialize();
//   //   await videoController?.dispose();
//   //   if (mounted) {
//   //     setState(() {
//   //       imageFile = null;
//   //       videoController = vController;
//   //     });
//   //   }
//   //   await vController.play();
//   // }

//   void _showCameraException(CameraException e) {
//     logError(e.code, e.description);
//     showInSnackBar('Error: ${e.code}\n${e.description}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       key: _scaffoldKey,
//       body: Stack(
//         children: [
//           cameraWidget(),
//           bottomBar(),
//           moreOptions(),
//           recordButton(context),
//           progressIndicator(),
//         ],
//       ),
//     );
//   }

//   Column cameraWidget() {
//     return Column(
//       children: <Widget>[
//         Center(
//           //TODO: Resolve this- gives error before showing the camera screen
//           child: Transform.scale(
//             scale: controller.value.aspectRatio,
//             child: _cameraPreviewWidget(),
//           ),
//         ),
//       ],
//     );
//   }

//   Padding progressIndicator() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       child: LinearProgressIndicator(
//         backgroundColor: iconsColor,
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//         value: ((_totalTimeInSeconds) / 30).toDouble(),
//       ),
//     );
//   }

//   Align recordButton(BuildContext context) {
//     return Align(
//       alignment: Alignment.topLeft,
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: IconButton(
//           icon: Icon(
//             Icons.cancel_outlined,
//             size: iconSize,
//           ),
//           color: iconsColor,
//           onPressed: () async {
//             print('cancel pressed');
//             // if (controller != null && controller.value.isInitialized) {
//             //   if (controller.value.isRecordingVideo) {
//             //     return await onStopButtonPressed();
//             //   }
//             //   if (controller.value.isRecordingPaused) {
//             //     return await onStopButtonPressed();
//             //   }
//             // }
//             await controller.dispose();
//             _timer.cancel();
//             // trimtimes = [];
//             _totalTimeInSeconds = 0;
//             _lasttime = 0;
//             _totalAndLastTime = [];
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//     );
//   }

//   Padding bottomBar() {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 40),
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: startPauseButton,
//                   child: CircleAvatar(
//                     radius: 30,
//                     backgroundColor: controller.value.isRecordingVideo && !controller.value.isRecordingPaused ? Colors.white : Colors.orange,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.flip_camera_android_outlined,
//                     color: Colors.white,
//                     size: iconSize,
//                   ),
//                   onPressed: changeCameraMode,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Align moreOptions() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.cancel_presentation_outlined,
//                   size: iconSize,
//                 ),
//                 color: iconsColor,
//                 onPressed: deleteLastClip,
//               ),
//               IconButton(
//                 icon: Icon(
//                   enableAudio ? Icons.volume_up : Icons.volume_off,
//                   size: iconSize,
//                 ),
//                 color: iconsColor,
//                 onPressed: () async {
//                   return controller != null ? onAudioModeButtonPressed : null;
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.flash_on,
//                   size: iconSize,
//                 ),
//                 color: iconsColor,
//                 onPressed: controller != null ? onFlashModeButtonPressed : null,
//               ),
//               _flashModeControlRowWidget(),
//               IconButton(
//                 icon: Icon(
//                   Icons.done,
//                   size: iconSize,
//                 ),
//                 color: iconsColor,
//                 onPressed: saveAndProceed,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
