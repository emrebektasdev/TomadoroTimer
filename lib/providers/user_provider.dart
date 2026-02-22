import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/shop_item.dart';

/// Provider for managing user data: tomato balance, purchases, settings
class UserProvider extends ChangeNotifier {
  // User balance
  int _tomatoBalance = 0;
  int _totalTomatoesEarned = 0;
  int _totalFocusMinutes = 0;
  int _currentStreak = 0;
  int _longestStreak = 0;
  DateTime? _lastActiveDate;

  // Purchased items
  List<String> _purchasedItemIds = [];

  // Equipped items
  String? _equippedAccessory;
  String? _equippedBackground;
  String? _equippedSound;

  // User settings
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Daily/Weekly goals
  int _dailyGoalMinutes = 120;
  int _weeklyGoalMinutes = 600;

  // Getters
  int get tomatoBalance => _tomatoBalance;
  int get totalTomatoesEarned => _totalTomatoesEarned;
  int get totalFocusMinutes => _totalFocusMinutes;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  DateTime? get lastActiveDate => _lastActiveDate;

  List<String> get purchasedItemIds => List.unmodifiable(_purchasedItemIds);

  String? get equippedAccessory => _equippedAccessory;
  String? get equippedBackground => _equippedBackground;
  String? get equippedSound => _equippedSound;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  int get dailyGoalMinutes => _dailyGoalMinutes;
  int get weeklyGoalMinutes => _weeklyGoalMinutes;

  /// Load user data from SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    _tomatoBalance = prefs.getInt('tomatoBalance') ?? 0;
    _totalTomatoesEarned = prefs.getInt('totalTomatoesEarned') ?? 0;
    _totalFocusMinutes = prefs.getInt('totalFocusMinutes') ?? 0;
    _currentStreak = prefs.getInt('currentStreak') ?? 0;
    _longestStreak = prefs.getInt('longestStreak') ?? 0;

    final lastActiveDateStr = prefs.getString('lastActiveDate');
    if (lastActiveDateStr != null) {
      _lastActiveDate = DateTime.parse(lastActiveDateStr);
    }

    _purchasedItemIds = prefs.getStringList('purchasedItemIds') ?? [];

    _equippedAccessory = prefs.getString('equippedAccessory');
    _equippedBackground = prefs.getString('equippedBackground');
    _equippedSound = prefs.getString('equippedSound');

    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;

    _dailyGoalMinutes = prefs.getInt('dailyGoalMinutes') ?? 120;
    _weeklyGoalMinutes = prefs.getInt('weeklyGoalMinutes') ?? 600;

    // Check and update streak
    _updateStreak();

    notifyListeners();
  }

  /// Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('tomatoBalance', _tomatoBalance);
    await prefs.setInt('totalTomatoesEarned', _totalTomatoesEarned);
    await prefs.setInt('totalFocusMinutes', _totalFocusMinutes);
    await prefs.setInt('currentStreak', _currentStreak);
    await prefs.setInt('longestStreak', _longestStreak);

    if (_lastActiveDate != null) {
      await prefs.setString(
        'lastActiveDate',
        _lastActiveDate!.toIso8601String(),
      );
    }

    await prefs.setStringList('purchasedItemIds', _purchasedItemIds);

    if (_equippedAccessory != null) {
      await prefs.setString('equippedAccessory', _equippedAccessory!);
    } else {
      await prefs.remove('equippedAccessory');
    }

    if (_equippedBackground != null) {
      await prefs.setString('equippedBackground', _equippedBackground!);
    } else {
      await prefs.remove('equippedBackground');
    }

    if (_equippedSound != null) {
      await prefs.setString('equippedSound', _equippedSound!);
    } else {
      await prefs.remove('equippedSound');
    }

    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool('soundEnabled', _soundEnabled);
    await prefs.setBool('vibrationEnabled', _vibrationEnabled);

    await prefs.setInt('dailyGoalMinutes', _dailyGoalMinutes);
    await prefs.setInt('weeklyGoalMinutes', _weeklyGoalMinutes);
  }

  /// Add tomatoes to balance (called after collecting a tomato)
  void addTomatoes(int amount) {
    _tomatoBalance += amount;
    _totalTomatoesEarned += amount;
    _saveUserData();
    notifyListeners();
  }

  // ============ DEBUG/TEST METHODS ============
  // These are for testing purposes and should be removed in production

  /// DEBUG: Instantly add tomatoes (for testing shop purchases)
  void debugAddTomatoes(int amount) {
    _tomatoBalance += amount;
    _saveUserData();
    notifyListeners();
  }

  // ============ END DEBUG METHODS ============

  /// Record completed focus session
  void recordFocusSession(int minutes) {
    _totalFocusMinutes += minutes;
    _lastActiveDate = DateTime.now();
    _updateStreak();
    _saveUserData();
    notifyListeners();
  }

  /// Purchase a shop item
  bool purchaseItem(ShopItem item) {
    if (_tomatoBalance < item.price) return false;
    if (_purchasedItemIds.contains(item.id)) return false;

    _tomatoBalance -= item.price;
    _purchasedItemIds.add(item.id);
    _saveUserData();
    notifyListeners();
    return true;
  }

  /// Check if an item is purchased
  bool isItemPurchased(String itemId) {
    return _purchasedItemIds.contains(itemId);
  }

  /// Equip an accessory
  void equipAccessory(String? accessoryId) {
    if (accessoryId != null && !_purchasedItemIds.contains(accessoryId)) return;
    _equippedAccessory = accessoryId;
    _saveUserData();
    notifyListeners();
  }

  /// Equip a background
  void equipBackground(String? backgroundId) {
    if (backgroundId != null && !_purchasedItemIds.contains(backgroundId)) {
      return;
    }
    _equippedBackground = backgroundId;
    _saveUserData();
    notifyListeners();
  }

  /// Equip a sound
  void equipSound(String? soundId) {
    if (soundId != null && !_purchasedItemIds.contains(soundId)) return;
    _equippedSound = soundId;
    _saveUserData();
    notifyListeners();
  }

  /// Update settings
  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _saveUserData();
    notifyListeners();
  }

  void setSoundEnabled(bool value) {
    _soundEnabled = value;
    _saveUserData();
    notifyListeners();
  }

  void setVibrationEnabled(bool value) {
    _vibrationEnabled = value;
    _saveUserData();
    notifyListeners();
  }

  /// Update goals
  void setDailyGoal(int minutes) {
    _dailyGoalMinutes = minutes;
    _saveUserData();
    notifyListeners();
  }

  void setWeeklyGoal(int minutes) {
    _weeklyGoalMinutes = minutes;
    _saveUserData();
    notifyListeners();
  }

  /// Update streak based on last active date
  void _updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastActiveDate == null) {
      _currentStreak = 1;
      _lastActiveDate = today;
      return;
    }

    final lastActive = DateTime(
      _lastActiveDate!.year,
      _lastActiveDate!.month,
      _lastActiveDate!.day,
    );

    final difference = today.difference(lastActive).inDays;

    if (difference == 0) {
      // Same day, streak unchanged
    } else if (difference == 1) {
      // Consecutive day, increment streak
      _currentStreak++;
      if (_currentStreak > _longestStreak) {
        _longestStreak = _currentStreak;
      }
    } else {
      // Streak broken
      _currentStreak = 1;
    }

    _lastActiveDate = today;
  }

  /// Get formatted total focus time
  String get formattedTotalFocusTime {
    final hours = _totalFocusMinutes ~/ 60;
    final minutes = _totalFocusMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
