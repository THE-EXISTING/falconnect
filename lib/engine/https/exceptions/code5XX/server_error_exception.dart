import 'package:falconnect/lib.dart';

/// Ref: https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
class ServerErrorException extends NetworkException {
  const ServerErrorException({
    required super.code,
    super.message,
    super.developerMessage,
    super.errors,
  }) : assert(code >= 500 && code < 600, 'Error code not 500 to 600');
}
