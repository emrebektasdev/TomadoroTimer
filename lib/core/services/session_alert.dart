import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class SessionAlert {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _ready;
  int _revision = 0;

  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> update({
    DateTime? end,
    bool chime = true,
    bool vibrate = true,
    bool focus = true,
  }) async {
    final revision = ++_revision;
    if (!supported) return;
    try {
      _ready ??= _plugin
          .initialize(
            const InitializationSettings(
              android: AndroidInitializationSettings('ic_session_leaf'),
              iOS: DarwinInitializationSettings(
                requestAlertPermission: false,
                requestSoundPermission: false,
                requestBadgePermission: false,
              ),
            ),
          )
          .then((_) {});
      await _ready;
      if (revision != _revision) return;
      await _plugin.cancel(1);
      if (end == null || revision != _revision) return;
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, sound: true);
      if (revision != _revision || !end.isAfter(DateTime.now())) return;
      final exact = await android?.canScheduleExactNotifications() ?? false;
      if (revision != _revision) return;
      await _plugin.zonedSchedule(
        1,
        focus ? 'Hasat zamanı' : 'Mola tamamlandı',
        focus
            ? 'Bir domates daha topladın. Biraz dinlen.'
            : 'Yeni seansın seni bekliyor.',
        tz.TZDateTime.from(end, tz.UTC),
        NotificationDetails(
          android: AndroidNotificationDetails(
            chime ? 'session_bell' : 'session_quiet',
            chime ? 'Seans zili' : 'Sessiz bitiş',
            importance: Importance.high,
            playSound: chime,
            enableVibration: vibrate,
          ),
          iOS: DarwinNotificationDetails(presentSound: chime),
        ),
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (error) {
      debugPrint('Bitiş bildirimi planlanamadı: $error');
    }
  }
}
