import 'package:falconnect/lib.dart';

class RequestTimeoutException extends ClientErrorException {
  const RequestTimeoutException({
    super.code = 408,
    super.developerMessage,
    super.message,
    super.errors,
    this.timeout,
  });

  final int? timeout;
}
