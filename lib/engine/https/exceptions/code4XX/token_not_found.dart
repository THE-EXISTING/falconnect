import 'package:falconnect/lib.dart';

class AuthorizedNotFoundException extends NetworkException {
  const AuthorizedNotFoundException(
      {required String service, int code = 403, String? message})
      : super(
            service: service,
            code: code,
            message: message ?? 'Token does not match target use');
}
