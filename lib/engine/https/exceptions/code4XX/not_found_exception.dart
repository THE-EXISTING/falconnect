import 'package:falconnect/lib.dart';

class NotFoundException extends ClientErrorException {
  const NotFoundException({
    super.code = 404,
    super.developerMessage,
    super.message,
    super.errors,
  });
}
