import 'package:logger/logger.dart' show DateTimeFormat, Logger, PrettyPrinter;

final logger = Logger(
  printer: PrettyPrinter(
    printEmojis: false,
    noBoxingByDefault: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
    methodCount: 1,
  ),
);
