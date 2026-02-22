/// Represents the timer mode
enum TimerMode {
  focus,
  shortBreak,
  longBreak,
}

/// Extension to get display properties for each timer mode
extension TimerModeExtension on TimerMode {
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
