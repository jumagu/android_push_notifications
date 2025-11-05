class PushNotification {
  final String id;
  final String title;
  final String body;
  final DateTime sentDate;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  PushNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.sentDate,
    this.data,
    this.imageUrl,
  });

  @override
  String toString() {
    return '''
      Push notification: 
        id: $id
        title: $title
        body: $body
        sentDate: $sentDate
        data: $data
        imageUrl: $imageUrl
    ''';
  }
}
