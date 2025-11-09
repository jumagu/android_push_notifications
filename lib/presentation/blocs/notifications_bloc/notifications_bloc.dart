import 'dart:io';

import 'package:android_push_notifications/domain/entities/push_notification.dart';
import 'package:android_push_notifications/firebase_options.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int notificationId = 0;

  final Future<void> Function()? requestLocalNotificationPermissionFn;
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })?
  showLocalNotificationFn;

  NotificationsBloc({
    this.showLocalNotificationFn,
    this.requestLocalNotificationPermissionFn,
  }) : super(NotificationsState()) {
    on<AuthorizationStatusChanged>(_onAuthorizationStatusChanged);
    on<PushNotificationReceived>(_onPushNotificationReceived);

    _checkInitialStatus();

    _onForegroundMessage(); // * Foreground notifications listener
  }

  // ? (Initialize Firebase Cloud Messaging)
  static Future<void> initFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // Request permission for local notification too
    if (requestLocalNotificationPermissionFn != null) {
      await requestLocalNotificationPermissionFn!();
    }

    add(AuthorizationStatusChanged(settings.authorizationStatus));
  }

  PushNotification? getPushNotificationById(String notificationId) {
    final exists = state.notifications.any(
      (element) => element.id == notificationId,
    );

    if (!exists) return null;

    return state.notifications.firstWhere(
      (element) => element.id == notificationId,
    );
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notification = PushNotification(
      id: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : null,
    );

    if (showLocalNotificationFn != null) {
      showLocalNotificationFn!(
        id: ++notificationId,
        title: notification.title,
        body: notification.body,
        data: notification.id,
      );
    }

    add(PushNotificationReceived(notification));
  }

  // * State Handlers
  void _onAuthorizationStatusChanged(
    AuthorizationStatusChanged event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _onPushNotificationReceived(
    PushNotificationReceived event,
    Emitter<NotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        notifications: [event.notification, ...state.notifications],
      ),
    );
  }

  // * Aux methods
  Future<void> _checkInitialStatus() async {
    final settings = await messaging.getNotificationSettings();
    add(AuthorizationStatusChanged(settings.authorizationStatus));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  Future<void> _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();

    print(token);
  }
}
