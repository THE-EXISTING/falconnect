import 'package:falconnect/lib.dart';

/// Ref: https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
class NetworkClientErrorException extends NetworkException {
  const NetworkClientErrorException({
    required super.code,
    super.developerMessage,
    super.message,
  }) : assert(code >= 400 && code < 500, 'Error code not 400 to 500');
}
