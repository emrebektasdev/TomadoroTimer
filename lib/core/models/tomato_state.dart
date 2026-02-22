/// Represents the growth state of the tomato during a focus session
enum TomatoState {
  unripe,    // Green/light - Start of session
  halfRipe,  // Orange - Half time
  ripe,      // Deep red - Session complete
  collectible, // Ready to be collected
}

/// Extension to get display properties for each tomato state
extension TomatoStateExtension on TomatoState {
  String get displayName {
    switch (this) {
      case TomatoState.unripe:
        return 'Unripe';
      case TomatoState.halfRipe:
        return 'Half Ripe';
      case TomatoState.ripe:
        return 'Ripe';
      case TomatoState.collectible:
        return 'Collectible';
    }
  }
  
  double get progressPercentage {
    switch (this) {
      case TomatoState.unripe:
        return 0.0;
      case TomatoState.halfRipe:
        return 0.5;
      case TomatoState.ripe:
        return 1.0;
      case TomatoState.collectible:
        return 1.0;
    }
  }
}
