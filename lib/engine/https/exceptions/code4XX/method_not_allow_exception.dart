import 'package:falconnect/lib.dart';

class MethodNotAllowedException extends NetworkClientErrorException {
  const MethodNotAllowedException({
    super.code = 405,
    super.developerMessage,
    String? message,
  }) : super(message: message ?? 'Server not found.');
}
