import 'package:falconnect/lib.dart';

class InternalErrorException extends NetworkServerErrorException {
  const InternalErrorException({
    super.code = 500,
    super.message = 'Service has something wrong.',
    super.developerMessage,
  });
}
