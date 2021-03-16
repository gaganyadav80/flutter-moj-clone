// import 'dart:async';

// import 'package:flutter/material.dart';

// class CameraTimer extends ChangeNotifier {
//   int _lasttime = 0;
//   int _totalTimeInSeconds = 0;
//   int _totalTimeInMilliseconds = 0;
//   Timer _timer;
//   List<List<int>> _trimtimes = [];
//   List<List<int>> _totalAndLastTime = [];
//   int get lasttime => _lasttime;
//   int get totalTimeInSeconds => _totalTimeInMilliseconds;
//   int get totalTimeInMilliseconds => _totalTimeInMilliseconds;
//   Timer get timer => _timer;
//   List<List<int>> get trimtimes => _trimtimes;
//   List<List<int>> get totalAndLastTime => totalAndLastTime;
//   bool _onStopButtonPressed = false;
//   set lasttime(int val) {
//     _lasttime = val;
//     notifyListeners();
//   }

//   set totalTimeInSeconds(int val) {
//     _totalTimeInSeconds = val;
//     notifyListeners();
//   }

//   set totalTimeInMilliseconds(int val) {
//     _totalTimeInMilliseconds = val;
//     notifyListeners();
//   }

//   bool get onStopButtonPressed => _onStopButtonPressed;

//   startTimer() {
//     _totalAndLastTime.add([_totalTimeInSeconds, _lasttime]);
//     _lasttime = 0;
//     _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
//       if (_totalTimeInMilliseconds <= 30000) {
//         if (_totalTimeInMilliseconds % 1000 == 0) {
//           _lasttime++;
//           _totalTimeInSeconds++;
//         }
//         _totalTimeInMilliseconds++;
//         print("Milliseconds  " + _totalTimeInMilliseconds.toString());
//       } else {
//         _onStopButtonPressed = true;
//         notifyListeners();
//       }
//       notifyListeners();
//     });
//   }

//   set trimTimes(List<List<int>> val) {
//     _trimtimes = val;
//     notifyListeners();
//   }

//   addToTrimTimes(List<int> val) {
//     _trimtimes.add(val);
//     notifyListeners();
//   }

//   cancelTimer() {
//     _timer.cancel();
//     notifyListeners();
//   }
// }
