import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Service for managing ambient sounds throughout the app
class SoundService extends ChangeNotifier {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  AudioPlayer? _audioPlayer;
  String? _currentSoundId;
  double _volume = 0.5;
  bool _isPlaying = false;
  bool _isEnabled = true;

  // Getters
  String? get currentSoundId => _currentSoundId;
  double get volume => _volume;
  bool get isPlaying => _isPlaying;
  bool get isEnabled => _isEnabled;

  /// Map of sound IDs to their asset URLs
  /// Using royalty-free online sources for demo purposes
  static const Map<String, String> _soundUrls = {
    'sound_rain':
        'https://assets.mixkit.co/active_storage/sfx/212/212-preview.mp3',
    'sound_forest':
        'https://assets.mixkit.co/active_storage/sfx/2502/2502-preview.mp3',
    'sound_ocean':
        'https://assets.mixkit.co/active_storage/sfx/2473/2473-preview.mp3',
    'sound_cafe':
        'https://assets.mixkit.co/active_storage/sfx/2514/2514-preview.mp3',
    'sound_fireplace':
        'https://assets.mixkit.co/active_storage/sfx/2497/2497-preview.mp3',
  };

  /// Initialize the audio player
  Future<void> initialize() async {
    _audioPlayer = AudioPlayer();
    _audioPlayer!.setReleaseMode(ReleaseMode.loop);

    // Listen for completion to handle looping
    _audioPlayer!.onPlayerComplete.listen((_) {
      if (_isPlaying && _currentSoundId != null) {
        // Restart the sound for seamless looping
        _playCurrentSound();
      }
    });
  }

  /// Set the sound enabled state
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled && _isPlaying) {
      stop();
    }
    notifyListeners();
  }

  /// Set the volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioPlayer?.setVolume(_volume);
    notifyListeners();
  }

  /// Play a sound by ID
  Future<void> play(String soundId) async {
    if (!_isEnabled) return;

    // Stop current sound if playing
    if (_isPlaying) {
      await stop();
    }

    _currentSoundId = soundId;
    await _playCurrentSound();
  }

  /// Play the current sound
  Future<void> _playCurrentSound() async {
    if (_currentSoundId == null) return;

    final url = _soundUrls[_currentSoundId];
    if (url == null) return;

    try {
      _audioPlayer ??= AudioPlayer();
      await _audioPlayer!.setVolume(_volume);
      await _audioPlayer!.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer!.play(UrlSource(url));
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing sound: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  /// Stop the current sound
  Future<void> stop() async {
    try {
      await _audioPlayer?.stop();
      _isPlaying = false;
      _currentSoundId = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping sound: $e');
    }
  }

  /// Pause the current sound
  Future<void> pause() async {
    try {
      await _audioPlayer?.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error pausing sound: $e');
    }
  }

  /// Resume the current sound
  Future<void> resume() async {
    if (!_isEnabled || _currentSoundId == null) return;

    try {
      await _audioPlayer?.resume();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error resuming sound: $e');
    }
  }

  /// Toggle play/pause
  Future<void> toggle() async {
    if (_isPlaying) {
      await pause();
    } else if (_currentSoundId != null) {
      await resume();
    }
  }

  /// Dispose the audio player
  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}
