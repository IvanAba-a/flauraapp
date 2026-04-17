import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings, 
    );
    
    // THE FIX: The parameter was renamed to just "settings" in the latest package version
    await _notificationsPlugin.initialize(
      settings: initSettings,
    );
  }

  static Future<void> showWarning({required int id, required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'flaura_alerts', 'Plant Alerts',
      importance: Importance.max, priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,  
      presentBadge: true,  
      presentSound: true,  
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // THE FIX: "details" was renamed to "notificationDetails"
    await _notificationsPlugin.show(
      id: id, 
      title: title, 
      body: body, 
      notificationDetails: platformDetails,
    );
  }
}