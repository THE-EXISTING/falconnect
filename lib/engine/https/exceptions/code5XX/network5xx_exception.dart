import 'package:falconnect/lib.dart';

class Network5XXException extends NetworkException {
  const Network5XXException({
    required super.code,
    super.message,
    super.developerMessage,
  }) : assert(code >= 500 && code < 600, 'Error code not 500 to 600');
}
