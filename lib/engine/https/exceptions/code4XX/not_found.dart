import 'package:falconnect/lib.dart';

class NotFoundException extends Network4XXException {
  const NotFoundException({
    super.code = 404,
    super.developerMessage,
    String? message,
  }) : super(message: message ?? 'Server not found.');
}
