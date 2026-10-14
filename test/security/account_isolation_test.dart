import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tomadoro/core/storage/account_storage.dart';
import 'package:tomadoro/features/history/data/datasources/history_local_datasource.dart';
import 'package:tomadoro/features/history/data/datasources/history_remote_datasource.dart';
import 'package:tomadoro/features/history/data/repositories/history_repository_impl.dart';
import 'package:tomadoro/features/history/domain/entities/focus_session.dart';

class FakeRemote implements HistoryRemoteDataSource {
  final writes = <String, List<FocusSession>>{};
  Completer<List<FocusSession>>? pending;
  @override
  Future<void> saveSessions(String uid, List<FocusSession> sessions) async {
    writes[uid] = sessions;
  }

  @override
  Future<List<FocusSession>> getSessions(String uid) async =>
      pending == null ? [] : pending!.future;
}

FocusSession session(String id) => FocusSession(
  id: id,
  startTime: DateTime(2026, 10, 14, 10),
  endTime: DateTime(2026, 10, 14, 10, 25),
  durationMinutes: 25,
  tomatoesEarned: 1,
);
void main() {
  late Directory temp;
  setUp(() async {
    temp = await Directory.systemTemp.createTemp('tomadoro-account-test');
    Hive.init(temp.path);
  });
  tearDown(() async {
    await Hive.close();
    await temp.delete(recursive: true);
  });
  test(
    'A → guest → B isolates profile, timer and unsynced history; returning A restores A',
    () async {
      final a = await AccountStorage.open('UserA');
      await a.boxes['user_profile']!.put('name', 'A');
      await a.boxes['timer_state']!.put('running', true);
      await HistoryLocalDataSource(
        a.boxes['daily_stats']!,
      ).saveSession(session('a-session'));
      for (final uid in [null, 'UserB', 'usera']) {
        final other = await AccountStorage.open(uid);
        expect(other.boxes['user_profile']!.get('name'), isNull);
        expect(other.boxes['timer_state']!.get('running'), isNull);
        expect(
          HistoryLocalDataSource(other.boxes['daily_stats']!).getAllSessions(),
          isEmpty,
        );
      }
      final again = await AccountStorage.open('UserA');
      expect(
        HistoryLocalDataSource(
          again.boxes['daily_stats']!,
        ).getUnsyncedSessions().single.id,
        'a-session',
      );
    },
  );
  test(
    'legacy unowned history is retained without being assigned to a newly signed-in account',
    () async {
      final legacy = await Hive.openBox('daily_stats');
      await HistoryLocalDataSource(legacy).saveSession(session('legacy'));
      final account = await AccountStorage.open('UserA');
      expect(
        HistoryLocalDataSource(account.boxes['daily_stats']!).getAllSessions(),
        isEmpty,
      );
      expect(
        HistoryLocalDataSource(legacy).getAllSessions().single.id,
        'legacy',
      );
    },
  );
  test(
    'old account cannot upload its pending history to B after switching',
    () async {
      final a = await AccountStorage.open('A');
      final local = HistoryLocalDataSource(a.boxes['daily_stats']!);
      await local.saveSession(session('private-a'));
      final remote = FakeRemote();
      String? current = 'B';
      final repo = HistoryRepositoryImpl(
        local,
        remote,
        accountId: 'A',
        currentUid: () => current,
      );
      expect((await repo.syncUnsyncedSessions('B')).isLeft(), isTrue);
      expect((await repo.syncUnsyncedSessions('A')).isLeft(), isTrue);
      expect(remote.writes, isEmpty);
      current = 'A';
      expect((await repo.syncUnsyncedSessions('A')).isRight(), isTrue);
      expect(remote.writes['A']!.single.id, 'private-a');
    },
  );
  test('in-flight restore is discarded after sign-out', () async {
    final a = await AccountStorage.open('A');
    final local = HistoryLocalDataSource(a.boxes['daily_stats']!);
    final remote = FakeRemote()..pending = Completer<List<FocusSession>>();
    String? current = 'A';
    final repo = HistoryRepositoryImpl(
      local,
      remote,
      accountId: 'A',
      currentUid: () => current,
    );
    final operation = repo.restoreSessionsFromBackend('A');
    current = null;
    remote.pending!.complete([session('remote-a')]);
    expect((await operation).isLeft(), isTrue);
    expect(local.getAllSessions(), isEmpty);
  });
}
