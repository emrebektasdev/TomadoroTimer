/// Timer mode enum.
library;

/// Represents the current mode of the timer.
enum TimerMode {
  focus,
  shortBreak,
  longBreak;

  /// Display name for the mode.
  String get displayName {
    switch (this) {
      case TimerMode.focus:
        return 'Focus';
      case TimerMode.shortBreak:
        return 'Short Break';
      case TimerMode.longBreak:
        return 'Long Break';
    }
  }

  /// Default duration in minutes.
  int get defaultMinutes {
    switch (this) {
      case TimerMode.focus:
        return 25;
      case TimerMode.shortBreak:
        return 5;
      case TimerMode.longBreak:
        return 15;
    }
  }
}
