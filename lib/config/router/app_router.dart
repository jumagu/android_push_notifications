import 'package:android_push_notifications/presentation/screens/detail_screen.dart';
import 'package:android_push_notifications/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/notification-detail/:notificationId',
      builder: (context, state) {
        return DetailScreen(
          notificationId: state.pathParameters['notificationId'] ?? '',
        );
      },
    ),
  ],
);
