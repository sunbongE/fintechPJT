class Notificate {
  final int individualNotificationId;
  final String title;
  final String content;
  final String time;
  final String type;

  Notificate({
    required this.individualNotificationId,
    required this.title,
    required this.content,
    required this.time,
    required this.type,
  });

  factory Notificate.fromJson(Map<String, dynamic> json) {
    return Notificate(
      individualNotificationId: json['individualNotificationId'],
      title: json['title'],
      content: json['content'],
      time: json['time'],
      type: json['type'],
    );
  }
}