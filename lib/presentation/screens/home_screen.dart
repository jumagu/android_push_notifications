import 'package:android_push_notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationsBloc bloc) => Text('Status: ${bloc.state.status.name}'),
        ),
        actions: [
          IconButton(
            onPressed: context.read<NotificationsBloc>().requestPermission,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<NotificationsBloc>().state.notifications.length,
      itemBuilder: (context, index) {
        final notification = context
            .watch<NotificationsBloc>()
            .state
            .notifications[index];

        return ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.body),
          leading: notification.imageUrl != null
              ? SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.network(
                    notification.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          onTap: () => context.push('/notification-detail/${notification.id}'),
        );
      },
    );
  }
}
