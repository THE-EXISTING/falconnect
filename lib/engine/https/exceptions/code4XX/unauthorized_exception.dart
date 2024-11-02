import 'package:falconnect/lib.dart';

class UnauthorizedException extends ClientErrorException {
  const UnauthorizedException({
    super.code = 401,
    super.developerMessage,
    super.message,
    super.errors,
  });
}
