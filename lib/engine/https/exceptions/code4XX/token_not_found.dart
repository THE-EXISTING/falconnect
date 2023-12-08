import 'package:falconnect/lib.dart';

class AuthorizedNotFoundException extends NetworkException {
  const AuthorizedNotFoundException({
    super.code = 403,
    super.developerMessage,
    String? message,
  }) : super(message: message ?? 'Token does not match target use');
}
