class UserMatches {
  final String? //icon,
      key,
      dateTime,
      pointsgreen,
      pointsred;

  UserMatches({
    this.key,
    this.dateTime,
    this.pointsgreen,
    this.pointsred,
  });

  factory UserMatches.fromRealTimeDB(Map<String, dynamic> data) {
    return UserMatches(
        pointsred: data['pointsred'] ?? '0',
        pointsgreen: data['pointsgreen'] ?? '0',
        dateTime: data['dateTime'] ?? '0',
    );
  }
}