class notification{
  String title;
  String disc;
  String timestamp;

  notification(this.title, this.disc, this.timestamp);

  factory notification.fromFirestore(Map<String, dynamic> data) {
    return notification(
      data['title'] ?? '',
      data['description'] ?? '',
      data['timestamp'].toDate().toString(),
    );
  }
}

