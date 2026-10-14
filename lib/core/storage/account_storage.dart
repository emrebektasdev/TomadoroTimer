import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Hex encoding preserves case-sensitive Firebase UIDs even though Hive lowercases names.
String accountBoxName(String base, String? uid) {
  final scope = uid == null
      ? 'guest'
      : utf8.encode(uid).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return 'account_v1_${scope}_$base';
}

final accountIdProvider = Provider<String?>(
  (ref) => throw StateError(
    'Account storage must be initialized before building the app.',
  ),
);

class AccountStorage {
  final String? uid;
  final Map<String, Box> boxes;
  AccountStorage._(this.uid, this.boxes);
  static Future<AccountStorage> open(String? uid) async {
    final boxes = <String, Box>{};
    for (final name in [
      'user_profile',
      'app_config',
      'shop_data',
      'timer_state',
      'daily_stats',
    ]) {
      boxes[name] = await Hive.openBox(accountBoxName(name, uid));
    }
    return AccountStorage._(uid, boxes);
  }
}
