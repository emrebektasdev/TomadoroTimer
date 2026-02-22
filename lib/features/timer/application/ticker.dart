/// Ticker for timer updates.
///
/// Emits a tick every second using a Stream.
library;

/// Ticker that emits an integer every second.
class Ticker {
  /// Returns a stream that emits int (tick count) every second.
  Stream<int> tick() {
    return Stream.periodic(const Duration(seconds: 1), (x) => x);
  }
}
