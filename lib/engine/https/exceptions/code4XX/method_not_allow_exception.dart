import 'package:falconnect/lib.dart';

class MethodNotAllowedException extends ClientErrorException {
  const MethodNotAllowedException({
    super.code = 405,
    super.developerMessage,
    super.message,
    super.errors,
  });
}
