import 'dart:async';
import 'dart:io';
import 'package:edverhub_video_editor/ui/components/logger.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import '../../utils.dart';

class CameraExampleHome extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraExampleHome({Key key, @required this.cameras}) : super(key: key);

  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

class _CameraExampleHomeState extends State<CameraExampleHome> with WidgetsBindingObserver, TickerProviderStateMixin {
  List<String> chipList = [
    "0.3x",
    "0.5x",
    " 1x ",
    " 2x ",
    " 3x ",
  ];
  Timer _timer;
  int videoSpeed = 1;
  int _lasttime = 0;
  int _totalTime = 0;
  int _cStart = 0;
  int _cEnd = 0;
  CameraController controller;
  XFile imageFile;
  XFile videoFile;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  AnimationController _flashModeControlRowAnimationController;
  Animation<double> _flashModeControlRowAnimation;
  AnimationController _exposureModeControlRowAnimationController;
  Animation<double> _exposureModeControlRowAnimation;
  AnimationController _focusModeControlRowAnimationController;
  Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom;
  double _maxAvailableZoom;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  List<CameraDescription> cameras;
  int _cameraMode = 0;
  List<List<int>> totallasttime = [];
  List<List<int>> trimtimes = [];
  Color iconsColor = Colors.white;
  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  Future<void> _future;
  double iconSize = 30;
  @override
  void initState() {
    super.initState();
    cameras = widget.cameras;
    controller = CameraController(
      cameras[0],
      ResolutionPreset.veryHigh,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _cameraMode = 0;
    _future = onNewCameraSelected(0);
    // _future = controller.setFocusMode(FocusMode.auto);
    WidgetsBinding.instance.addObserver(this);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  _startTimer() {
    totallasttime.add([_totalTime, _lasttime]);
    _lasttime = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_totalTime <= 30) {
          _lasttime++;
          _totalTime++;
        } else {
          setState(() {
            onStopButtonPressed();
          });
        }
      });
    });
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   _flashModeControlRowAnimationController.dispose();
  //   _exposureModeControlRowAnimationController.dispose();
  //   super.dispose();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(_cameraMode);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: Text(
          'Tap a camera',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _handleScaleStart,
                onScaleUpdate: _handleScaleUpdate,
                onTapDown: (details) => onViewFinderTap(details, constraints),
              );
            },
          ),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //TODO: change
          videoController == null && imageFile == null
              ? Container()
              : SizedBox(
                  child: (videoController == null)
                      ? Image.file(File(imageFile.path))
                      : Container(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: videoController.value.size != null ? videoController.value.aspectRatio : 1.0,
                              child: VideoPlayer(
                                videoController,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(border: Border.all(color: Colors.pink)),
                        ),
                  width: 64.0,
                  height: 64.0,
                ),
        ],
      ),
    );
  }

  Widget _flashModeControlRowWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizeTransition(
        sizeFactor: _flashModeControlRowAnimation,
        child: ClipRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: Icon(
                  Icons.flash_off,
                  size: iconSize,
                ),
                color: controller?.value?.flashMode == FlashMode.off ? Colors.orange : Colors.white,
                onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.off) : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.flash_auto,
                  size: iconSize,
                ),
                color: controller?.value?.flashMode == FlashMode.auto ? Colors.orange : Colors.white,
                onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.auto) : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.flash_on,
                  size: iconSize,
                ),
                color: controller?.value?.flashMode == FlashMode.always ? Colors.orange : Colors.white,
                onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.always) : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.highlight,
                  size: iconSize,
                ),
                color: controller?.value?.flashMode == FlashMode.torch ? Colors.orange : Colors.white,
                onPressed: controller != null ? () => onSetFlashModeButtonPressed(FlashMode.torch) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller.setExposurePoint(offset);
    controller.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(int cameradesc) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(
      cameras[cameradesc],
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      await Future.wait([
        controller.getMinExposureOffset().then((value) => _minAvailableExposureOffset = value),
        controller.getMaxExposureOffset().then((value) => _maxAvailableExposureOffset = value),
        controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
        controller.getMinZoomLevel().then((value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(_cameraMode);
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  void onVideoRecordButtonPressed() {
    _startTimer();
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    _timer.cancel();
    stopVideoRecording().then((file) {
      if (mounted)
        setState(() {
          _lasttime = 0;
        });
      if (file != null) {
        showInSnackBar('Video recorded to ${file.path}');

        // videoFile = file;
        // _startVideoPlayer();
      }
    });
  }

  void onPauseButtonPressed() {
    _timer.cancel();
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    _startTimer();
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await controller.startVideoRecording().then((value) => setState(() {}));
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      return controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    try {
      await controller.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vController = VideoPlayerController.file(File(videoFile.path));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vController.addListener(videoPlayerListener);
    await vController.setLooping(true);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Center(
                child: Transform.scale(
                  scale: controller.value.aspectRatio,
                  child: _cameraPreviewWidget(),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChoiceChipWidget(chipList),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // if (_seconds <= 30) {}
                          return controller != null && controller.value.isInitialized && !controller.value.isRecordingVideo
                              ? onVideoRecordButtonPressed()
                              : (controller.value.isRecordingPaused)
                                  ? _totalTime < 30
                                      ? onResumeButtonPressed()
                                      : showInSnackBar('30 seconds Completed')
                                  : onPauseButtonPressed();
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: controller.value.isRecordingVideo && !controller.value.isRecordingPaused ? Colors.white : Colors.orange,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.flip_camera_android_outlined,
                          color: Colors.white,
                          size: iconSize,
                        ),
                        onPressed: () {
                          if (_cameraMode == 0)
                            _cameraMode = 1;
                          else
                            _cameraMode = 0;
                          setState(() {
                            onNewCameraSelected(_cameraMode);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.cancel_presentation_outlined,
                        size: iconSize,
                      ),
                      color: iconsColor,
                      onPressed: () async {
                        if (controller != null && controller.value.isInitialized && controller.value.isRecordingVideo) {
                          if (controller.value.isRecordingPaused) {
                            if (_totalTime == 0) {
                              showInSnackBar('No clip to delete');
                            } else {
                              trimtimes.add([_totalTime - _lasttime, _totalTime]);
                              _totalTime = _totalTime - _lasttime;
                              _lasttime = totallasttime[totallasttime.length - 1][1];

                              showInSnackBar('Clip deleted');
                            }
                          } else {
                            showInSnackBar('You have to stop the video');
                          }
                        } else {
                          showInSnackBar('You haven\'t recorded any clip yet');
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        enableAudio ? Icons.volume_up : Icons.volume_off,
                        size: iconSize,
                      ),
                      color: iconsColor,
                      onPressed: controller != null ? onAudioModeButtonPressed : null,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.flash_on,
                        size: iconSize,
                      ),
                      color: iconsColor,
                      onPressed: controller != null ? onFlashModeButtonPressed : null,
                    ),
                    _flashModeControlRowWidget(),
                    IconButton(
                      icon: Icon(
                        Icons.done,
                        size: iconSize,
                      ),
                      color: iconsColor,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  size: iconSize,
                ),
                color: iconsColor,
                onPressed: () {
                  print('cancel pressed');
                  if (controller != null && controller.value.isInitialized) {
                    if (controller.value.isRecordingVideo) {
                      return onStopButtonPressed();
                    }
                    if (controller.value.isRecordingPaused) {
                      return onStopButtonPressed();
                    }
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: LinearProgressIndicator(
              backgroundColor: iconsColor,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              value: ((_totalTime) / 30).toDouble(),
            ),
          ),
        ],
      ),
    );
  }
}

void logError(String code, String message) => print('Error: $code\nError Message: $message');

class ChoiceChipWidget extends StatefulWidget {
  final List<String> reportList;

  ChoiceChipWidget(this.reportList);

  @override
  _ChoiceChipWidgetState createState() => new _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  String selectedChoice = " 1x ";

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: Color(0xffededed),
          selectedColor: Color(0xffffc107),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
