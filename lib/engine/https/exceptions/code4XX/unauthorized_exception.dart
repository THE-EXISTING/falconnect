import 'package:falconnect/lib.dart';

class UnauthorizedException extends NetworkClientErrorException {
  const UnauthorizedException({
    super.code = 401,
    String super.message = 'You have to login first.',
    super.developerMessage,
  });
}
