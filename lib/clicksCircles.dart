class UserTry {
  final String? //icon,
      key,
      dateTime,
      coordinate,
      colorCircle;

  final int indexLastClick;

  UserTry({
    this.key,
    required this.indexLastClick,
    this.dateTime,
    this.coordinate,
    this.colorCircle,
  });

  factory UserTry.fromRealTimeDB(Map<String, dynamic> data) {
    return UserTry(
        coordinate: data['coordinate'] ?? 'coordinate',
        colorCircle: data['colorCircle'] ?? 'color',
        dateTime: data['dateTime'] ?? '0',
        indexLastClick: data['indexLastMessage'] ?? '0'
    );
  }
}