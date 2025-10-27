import 'package:android_push_notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      itemCount: 0,
      itemBuilder: (context, index) {
        return const ListTile();
      },
    );
  }
}
