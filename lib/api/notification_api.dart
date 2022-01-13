import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
class NotificationApi{

  static final _notifications=FlutterLocalNotificationsPlugin();
  static final onNotifications=BehaviorSubject<String?>();

  static Future notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }
  static Future init({bool initScheduled=false}) async{
    final android=AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS=IOSInitializationSettings();
    final settings=InitializationSettings(android: android,iOS: iOS);

    //When the app is closed
    final details= await _notifications.getNotificationAppLaunchDetails();
    if(details!=null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async{
        onNotifications.add(payload);
      },
    );
    if(initScheduled){
      tz.initializeTimeZones();
      final locationName=await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));

    }
  }

  static Future showNotification({
    int id=0, //todos tablosunda notification id yi tutarak bittiye çekince notification iptali yapılabilir.
    String? title,
    String? body,
    String? payload,
  })async=>
      _notifications.show(
          id,
          title,
          body,
          await notificationDetails(),
          payload: payload
      );


  static Future showScheduledNotification({
    int id=0, //todos tablosunda notification id yi tutarak bittiye çekince notification iptali yapılabilir.
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async=>
    _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate,tz.local),
      await notificationDetails(),
      payload: payload,
      androidAllowWhileIdle:true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

  static void cancel(int id) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();
}
