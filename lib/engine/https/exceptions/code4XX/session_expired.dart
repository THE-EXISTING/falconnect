import 'package:falconnect/falconnect.dart';

class SessionExpiredException extends NetworkException {
  const SessionExpiredException(
      {required String service,
      int code = 401,
      String message = 'You access token is expired.'})
      : super(service: service, code: code, message: message);
}
