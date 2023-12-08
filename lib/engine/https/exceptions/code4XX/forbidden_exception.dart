import 'package:falconnect/lib.dart';

class ForbiddenException extends NetworkException {
  const ForbiddenException({
    super.code = 403,
    super.developerMessage,
    super.message,
  });
}
