import 'package:falconnect/lib.dart';

class UnauthorizedException extends Network4XXException {
  const UnauthorizedException({
    super.code = 401,
    String super.message = 'You have to login first.',
    super.developerMessage,
  });
}
