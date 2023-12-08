import 'package:falconnect/lib.dart';

class BadRequestException extends NetworkClientErrorException {
  const BadRequestException({
    super.code = 400,
    super.developerMessage,
    String? message,
  }) : super(message: message ?? 'Bad request.');
}
