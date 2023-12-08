import 'package:falconnect/lib.dart';

class BadRequestException extends Network4XXException {
  const BadRequestException({
    super.code = 400,
    super.developerMessage,
    String? message,
  }) : super(message: message ?? 'Bad request.');
}
