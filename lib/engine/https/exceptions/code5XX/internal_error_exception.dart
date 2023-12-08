import 'package:falconnect/lib.dart';

class InternalErrorException extends Network5XXException {
  const InternalErrorException({
    super.code = 500,
    super.message = 'Service has something wrong.',
    super.developerMessage,
  });
}
