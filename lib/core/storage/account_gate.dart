import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../di/core_providers.dart';
import '../services/sound_service.dart';
import '../../features/user/application/user_providers.dart';
import '../../features/history/application/history_providers.dart';
import '../../features/timer/application/timer_providers.dart';
import 'account_storage.dart';

class AccountGate extends StatefulWidget {
  final Widget child;
  final SoundService soundService;
  const AccountGate({
    super.key,
    required this.child,
    required this.soundService,
  });
  @override
  State<AccountGate> createState() => _AccountGateState();
}

class _AccountGateState extends State<AccountGate> {
  late String? _uid;
  late Future<AccountStorage> _storage;
  late StreamSubscription<User?> _subscription;
  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid;
    _storage = AccountStorage.open(_uid);
    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (!mounted || user?.uid == _uid) return;
      setState(() {
        _uid = user?.uid;
        _storage = AccountStorage.open(_uid);
      });
    });
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AccountStorage>(
      key: ValueKey(_uid),
      future: _storage,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Hesap verileri açılamadı. Uygulamayı yeniden başlatın.',
                ),
              ),
            ),
          );
        }
        final storage = snapshot.data;
        if (storage == null) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return ProviderScope(
          key: ValueKey('account:${storage.uid}'),
          overrides: [
            soundServiceProvider.overrideWithValue(widget.soundService),
            accountIdProvider.overrideWithValue(storage.uid),
            userBoxProvider.overrideWithValue(storage.boxes['user_profile']!),
            userProfileBoxProvider.overrideWithValue(
              storage.boxes['user_profile']!,
            ),
            historyBoxProvider.overrideWithValue(storage.boxes['daily_stats']!),
            timerBoxProvider.overrideWithValue(storage.boxes['timer_state']!),
            appConfigBoxProvider.overrideWithValue(
              storage.boxes['app_config']!,
            ),
            shopDataBoxProvider.overrideWithValue(storage.boxes['shop_data']!),
          ],
          child: widget.child,
        );
      },
    );
  }
}
