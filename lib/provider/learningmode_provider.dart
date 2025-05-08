// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class LearningModeProvider extends ChangeNotifier {
//   bool _isLearningModeActive = false;
//   int _elapsedSeconds = 0;
//   Timer? _timer;
//
//   bool get isLearningModeActive => _isLearningModeActive;
//   int get elapsedSeconds => _elapsedSeconds;
//
//   // Start the learning mode and the timer
//   void startLearningMode() {
//     if (!_isLearningModeActive) {
//       _isLearningModeActive = true;
//       _elapsedSeconds = 0;  // Reset the timer when learning mode starts
//       _timer?.cancel(); // Cancel any existing timer
//       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         _elapsedSeconds++;
//         notifyListeners();  // Update listeners every second
//       });
//     }
//     notifyListeners(); // Ensure the state is updated when learning mode starts
//   }
//
//   // Stop the learning mode and the timer
//   void stopLearningMode() {
//     if (_isLearningModeActive) {
//       _isLearningModeActive = false;
//       _timer?.cancel();  // Stop the timer
//       notifyListeners(); // Notify listeners that the timer has stopped
//     }
//   }
//
//   // Reset the learning mode and timer
//   void resetLearningMode() {
//     _isLearningModeActive = false;
//     _timer?.cancel(); // Cancel the running timer
//     _elapsedSeconds = 0; // Reset the elapsed time
//     notifyListeners();
//   }
// }
//

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningModeProvider extends ChangeNotifier {
  bool _isLearningModeActive = false;
  int _elapsedSeconds = 0;
  Timer? _timer;

  bool get isLearningModeActive => _isLearningModeActive;
  int get elapsedSeconds => _elapsedSeconds;

  LearningModeProvider() {
    _loadState(); // Load state when provider is initialized
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
      _saveState(); // Save to storage every second
    });
  }

  Future<void> startLearningMode() async {
    if (!_isLearningModeActive) {
      _isLearningModeActive = true;
      _elapsedSeconds = 0;
      _timer?.cancel();
      _startTimer();
      await _saveState(); // Save on start
    }
    notifyListeners();
  }

  Future<void> stopLearningMode() async {
    if (_isLearningModeActive) {
      _isLearningModeActive = false;
      _timer?.cancel();
      await _saveState(); // Save on stop
      notifyListeners();
    }
  }

  Future<void> resetLearningMode() async {
    _isLearningModeActive = false;
    _elapsedSeconds = 0;
    _timer?.cancel();
    await _saveState();
    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('learning_mode_active', _isLearningModeActive);
    await prefs.setInt('learning_mode_elapsed', _elapsedSeconds);
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLearningModeActive = prefs.getBool('learning_mode_active') ?? false;
    _elapsedSeconds = prefs.getInt('learning_mode_elapsed') ?? 0;

    if (_isLearningModeActive) {
      _startTimer(); // Resume timer if it was active
    }

    notifyListeners();
  }
}

