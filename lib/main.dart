import 'package:android_push_notifications/config/local_notifications/local_notifications.dart';
import 'package:android_push_notifications/config/router/app_router.dart';
import 'package:android_push_notifications/config/theme/app_theme.dart';
import 'package:android_push_notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationsBloc.initFCM();
  await LocalNotifications.initLocalNotifications();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationsBloc(
            showLocalNotificationFn: LocalNotifications.showLocalNotification,
            requestLocalNotificationPermissionFn:
                LocalNotifications.requestPermissionLocalNotification,
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      builder: (context, child) {
        return NotificationInteractionHandler(child: child!);
      },
    );
  }
}

class NotificationInteractionHandler extends StatefulWidget {
  final Widget child;

  const NotificationInteractionHandler({super.key, required this.child});

  @override
  State<NotificationInteractionHandler> createState() {
    return _NotificationInteractionHandlerState();
  }
}

class _NotificationInteractionHandlerState
    extends State<NotificationInteractionHandler> {
  // In this example, suppose that all messages contain a data field with the key 'type'.
  Future setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background using a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    final notificationId = message.messageId
        ?.replaceAll(':', '')
        .replaceAll('%', '');

    // We use this instead of context.push to avoid issues if the router is not initializated.
    appRouter.push('/notification-detail/$notificationId');
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
