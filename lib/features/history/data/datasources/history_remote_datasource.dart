import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/focus_session.dart';

class HistoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  HistoryRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveSessions(String uid, List<FocusSession> sessions) async {
    try {
      final batch = _firestore.batch();
      final sessionsRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('sessions');

      for (final session in sessions) {
        final docRef = sessionsRef.doc(session.id);
        batch.set(docRef, _sessionToMap(session), SetOptions(merge: true));
      }

      await batch.commit();
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to sync sessions to Firestore',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<FocusSession>> getSessions(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('sessions')
          .get();

      return snapshot.docs
          .map((doc) => _sessionFromMap(doc.id, doc.data()))
          .toList();
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to fetch sessions from Firestore',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Map<String, dynamic> _sessionToMap(FocusSession session) {
    return {
      'startTime': session.startTime.toIso8601String(),
      'endTime': session.endTime.toIso8601String(),
      'durationMinutes': session.durationMinutes,
      'tomatoesEarned': session.tomatoesEarned,
      'completed': session.completed,
      'isSynced': true, // Always true when existing in remote
      'syncedAt': FieldValue.serverTimestamp(),
    };
  }

  FocusSession _sessionFromMap(String id, Map<String, dynamic> map) {
    return FocusSession(
      id: id,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      durationMinutes: map['durationMinutes'] as int,
      tomatoesEarned: map['tomatoesEarned'] as int,
      completed: map['completed'] as bool? ?? true,
      isSynced: true, // Synced because it came from remote
    );
  }
}
