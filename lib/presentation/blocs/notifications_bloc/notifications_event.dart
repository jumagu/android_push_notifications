part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class AuthorizationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  const AuthorizationStatusChanged(this.status);
}

class PushNotificationReceived extends NotificationsEvent {
  final PushNotification notification;

  const PushNotificationReceived(this.notification);
}
