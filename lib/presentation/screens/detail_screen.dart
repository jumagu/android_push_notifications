import 'package:android_push_notifications/domain/entities/push_notification.dart';
import 'package:android_push_notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailScreen extends StatelessWidget {
  final String notificationId;

  const DetailScreen({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context) {
    final notification = context
        .read<NotificationsBloc>()
        .getPushNotificationById(notificationId);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: (notification != null)
          ? _DetailsView(notification: notification)
          : const Center(child: Text('Notification does not exists.')),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushNotification notification;

  const _DetailsView({required this.notification});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        spacing: 10,
        children: [
          if (notification.imageUrl != null)
            SizedBox(
              width: 150,
              height: 150,
              child: Image.network(notification.imageUrl!, fit: BoxFit.cover),
            ),

          Text(notification.title, style: textStyles.titleMedium),
          Text(notification.body),

          const Divider(),

          Text(notification.data.toString()),
        ],
      ),
    );
  }
}
