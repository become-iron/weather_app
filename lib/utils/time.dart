/// - [dateTime]: An integer representing the UNIX timestamp (in seconds).
DateTime parseUnixTimestamp(int dateTime) {
  return DateTime.fromMillisecondsSinceEpoch(
    dateTime * 1000,
    isUtc: true,
  ).toLocal();
}
