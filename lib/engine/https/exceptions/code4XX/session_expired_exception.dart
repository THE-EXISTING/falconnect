import 'package:falconnect/lib.dart';

class SessionExpiredException extends ClientErrorException {
  const SessionExpiredException({
    super.code = 401,
    super.message,
    super.developerMessage,
    super.errors,
  });
}
