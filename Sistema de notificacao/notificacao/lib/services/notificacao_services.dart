import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacaoServices {
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> inicializar() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await plugin.initialize(settings: settings);
  }

  Future<void> solicitarPermissao() async {
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  Future<void> mostrarNotificacao() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'canal_principal',
      'Canal_principal',
      channelDescription: 'Notificações principal do Aplicativo',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      id: 1,
      title: 'Olá!',
      body: 'Esta é uma notificação do aplicativo.',
      notificationDetails: details,
    );
  }
}