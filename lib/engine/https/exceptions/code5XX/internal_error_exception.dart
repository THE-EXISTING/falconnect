import 'package:falconnect/lib.dart';

class InternalErrorException extends Network5XXException {
  const InternalErrorException(
      {required service,
      int code = 500,
      String? message = 'Service has something wrong.'})
      : super(service: service, code: code, message: message);
}
