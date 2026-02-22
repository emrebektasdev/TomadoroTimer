/// Duration extension methods for formatting and calculations.
library;

extension DurationX on Duration {
  /// Formats duration as MM:SS
  String get formatted {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats duration as HH:MM:SS
  String get formattedWithHours {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats duration as human-readable string (e.g., "2h 30m")
  String get humanReadable {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Returns the remaining duration after subtracting [other]
  Duration remaining(Duration other) {
    final diff = this - other;
    return diff.isNegative ? Duration.zero : diff;
  }
}

extension IntDurationX on int {
  /// Creates Duration from minutes
  Duration get minutes => Duration(minutes: this);

  /// Creates Duration from seconds
  Duration get seconds => Duration(seconds: this);

  /// Creates Duration from hours
  Duration get hours => Duration(hours: this);
}
