import 'package:falconnect/lib.dart';

/// Ref: https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
class ClientErrorException extends NetworkException {
  const ClientErrorException({
    required super.code,
    super.developerMessage,
    super.message,
    super.errors,
  }) : assert(code >= 400 && code < 500, 'Error code not 400 to 500');
}
