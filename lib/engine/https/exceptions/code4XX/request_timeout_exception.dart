import 'package:falconnect/lib.dart';

class RequestTimeoutException extends NetworkClientErrorException {
  const RequestTimeoutException({
    super.code = 408,
    super.developerMessage,
    int? timeout,
    super.message,
  });
}
