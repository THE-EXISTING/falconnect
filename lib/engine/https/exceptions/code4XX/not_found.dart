import 'package:falconnect/lib.dart';

class NotFoundException extends Network4XXException {
  const NotFoundException(
      {required String service, int code = 404, String? message})
      : super(
            service: service,
            code: code,
            message: message ?? 'Server not found.');
}
