import 'package:falconnect/lib.dart';

class SessionExpiredException extends NetworkClientErrorException {
  const SessionExpiredException({
    super.code = 401,
    super.message = 'You access token is expired.',
    super.developerMessage,
  });
}
