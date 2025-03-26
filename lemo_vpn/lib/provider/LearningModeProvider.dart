import 'dart:async';
import 'package:flutter/material.dart';

class LearningModeProvider extends ChangeNotifier {
  bool _isLearningModeActive = false;
  int _elapsedSeconds = 0;
  Timer? _timer;

  bool get isLearningModeActive => _isLearningModeActive;
  int get elapsedSeconds => _elapsedSeconds;

  // Start the learning mode and the timer
  void startLearningMode() {
    if (!_isLearningModeActive) {
      _isLearningModeActive = true;
      _elapsedSeconds = 0;  // Reset the timer when learning mode starts
      _timer?.cancel(); // Cancel any existing timer
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedSeconds++;
        notifyListeners();  // Update listeners every second
      });
    }
    notifyListeners(); // Ensure the state is updated when learning mode starts
  }

  // Stop the learning mode and the timer
  void stopLearningMode() {
    if (_isLearningModeActive) {
      _isLearningModeActive = false;
      _timer?.cancel();  // Stop the timer
      notifyListeners(); // Notify listeners that the timer has stopped
    }
  }

  // Reset the learning mode and timer
  void resetLearningMode() {
    _isLearningModeActive = false;
    _timer?.cancel(); // Cancel the running timer
    _elapsedSeconds = 0; // Reset the elapsed time
    notifyListeners();
  }
}
