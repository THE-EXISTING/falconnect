import 'package:falconnect/lib.dart';

class Network4XXException extends NetworkException {
  const Network4XXException({
    required super.code,
    super.developerMessage,
    super.message,
  }) : assert(code >= 400 && code < 500, 'Error code not 400 to 500');
}
