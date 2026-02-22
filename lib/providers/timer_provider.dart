import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/models/tomato_state.dart';
import '../../core/models/timer_mode.dart';

/// Callback type for when a focus session completes
typedef OnFocusCompleteCallback = void Function();

/// Provider for managing the Pomodoro timer state
class TimerProvider extends ChangeNotifier {
  // Timer configuration
  int _focusDurationMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;
  final int _sessionsBeforeLongBreak = 4;

  // Timer state
  TimerMode _currentMode = TimerMode.focus;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  int _completedSessions = 0;
  TomatoState _tomatoState = TomatoState.unripe;
  bool _isCollectible = false;
  bool _pendingBreakChoice = false; // New: waiting for user to choose break

  Timer? _timer;
  DateTime? _sessionStartTime;

  // Callback for focus session completion (to show break modal)
  OnFocusCompleteCallback? onFocusComplete;

  // Getters
  int get focusDurationMinutes => _focusDurationMinutes;
  int get shortBreakMinutes => _shortBreakMinutes;
  int get longBreakMinutes => _longBreakMinutes;
  int get sessionsBeforeLongBreak => _sessionsBeforeLongBreak;

  TimerMode get currentMode => _currentMode;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  int get completedSessions => _completedSessions;
  TomatoState get tomatoState => _tomatoState;
  bool get isCollectible => _isCollectible;
  bool get pendingBreakChoice => _pendingBreakChoice;
  DateTime? get sessionStartTime => _sessionStartTime;

  /// Progress from 0.0 to 1.0
  double get progress {
    final totalSeconds = _getTotalSecondsForMode(_currentMode);
    if (totalSeconds == 0) return 0;
    return 1.0 - (_remainingSeconds / totalSeconds);
  }

  /// Formatted time string (MM:SS)
  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Tomatoes earned for completed session
  int get tomatoesEarned {
    return _focusDurationMinutes ~/ 25;
  }

  // Timer Configuration Methods
  void setFocusDuration(int minutes) {
    _focusDurationMinutes = minutes;
    if (_currentMode == TimerMode.focus && !_isRunning) {
      _remainingSeconds = minutes * 60;
    }
    notifyListeners();
  }

  void setShortBreakDuration(int minutes) {
    _shortBreakMinutes = minutes;
    if (_currentMode == TimerMode.shortBreak && !_isRunning) {
      _remainingSeconds = minutes * 60;
    }
    notifyListeners();
  }

  void setLongBreakDuration(int minutes) {
    _longBreakMinutes = minutes;
    if (_currentMode == TimerMode.longBreak && !_isRunning) {
      _remainingSeconds = minutes * 60;
    }
    notifyListeners();
  }

  // Timer Control Methods
  void startTimer() {
    if (_isRunning || _isCollectible) return;

    _isRunning = true;
    _sessionStartTime ??= DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _updateTomatoState();
        notifyListeners();
      } else {
        _onTimerComplete();
      }
    });

    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _remainingSeconds = _getTotalSecondsForMode(_currentMode);
    _tomatoState = TomatoState.unripe;
    _isCollectible = false;
    _sessionStartTime = null;
    notifyListeners();
  }

  void switchMode(TimerMode mode) {
    if (_isRunning) return;

    _currentMode = mode;
    _remainingSeconds = _getTotalSecondsForMode(mode);
    _tomatoState = TomatoState.unripe;
    _isCollectible = false;
    _sessionStartTime = null;
    notifyListeners();
  }

  /// Collect the tomato after completing a focus session
  /// Returns the number of tomatoes earned
  /// Note: Does NOT auto-start break - user must choose via break modal
  int collectTomato() {
    if (!_isCollectible || _currentMode != TimerMode.focus) return 0;

    final earned = tomatoesEarned;
    _completedSessions++;

    // Mark that we're waiting for user's break choice
    _pendingBreakChoice = true;
    _tomatoState = TomatoState.unripe;
    _isCollectible = false;
    _sessionStartTime = null;

    // Trigger callback so UI can show break choice modal
    onFocusComplete?.call();

    notifyListeners();
    return earned;
  }

  /// Start a short break (called after user chooses from break modal)
  void startShortBreak() {
    _pendingBreakChoice = false;
    _currentMode = TimerMode.shortBreak;
    _remainingSeconds = _shortBreakMinutes * 60;
    _tomatoState = TomatoState.unripe;
    notifyListeners();
    startTimer();
  }

  /// Start a long break (called after user chooses from break modal)
  void startLongBreak() {
    _pendingBreakChoice = false;
    _currentMode = TimerMode.longBreak;
    _remainingSeconds = _longBreakMinutes * 60;
    _tomatoState = TomatoState.unripe;
    notifyListeners();
    startTimer();
  }

  /// Skip break and return to focus mode (called after user chooses from break modal)
  void skipBreakAndFocus() {
    _pendingBreakChoice = false;
    _currentMode = TimerMode.focus;
    _remainingSeconds = _focusDurationMinutes * 60;
    _tomatoState = TomatoState.unripe;
    notifyListeners();
  }

  // ============ DEBUG/TEST METHODS ============
  // These are for testing purposes and should be removed in production

  /// DEBUG: Instantly ripen the tomato (set timer to complete)
  void debugInstantRipen() {
    if (_currentMode != TimerMode.focus) return;

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _remainingSeconds = 0;
    _tomatoState = TomatoState.collectible;
    _isCollectible = true;
    notifyListeners();
  }

  // ============ END DEBUG METHODS ============

  // Private Methods
  int _getTotalSecondsForMode(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus:
        return _focusDurationMinutes * 60;
      case TimerMode.shortBreak:
        return _shortBreakMinutes * 60;
      case TimerMode.longBreak:
        return _longBreakMinutes * 60;
    }
  }

  void _updateTomatoState() {
    if (_currentMode != TimerMode.focus) return;

    if (progress < 0.5) {
      _tomatoState = TomatoState.unripe;
    } else if (progress < 1.0) {
      _tomatoState = TomatoState.halfRipe;
    } else {
      _tomatoState = TomatoState.ripe;
    }
  }

  void _onTimerComplete() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;

    if (_currentMode == TimerMode.focus) {
      _tomatoState = TomatoState.collectible;
      _isCollectible = true;
    } else {
      // Break complete, switch to focus mode
      _currentMode = TimerMode.focus;
      _remainingSeconds = _focusDurationMinutes * 60;
      _tomatoState = TomatoState.unripe;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
