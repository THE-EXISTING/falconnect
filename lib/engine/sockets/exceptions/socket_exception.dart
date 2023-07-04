import 'package:falconnect/lib.dart';
import 'package:falmodel/falmodel.dart';
import 'package:faltool/faltool.dart';

class SocketException implements Exception {
  const SocketException({
    this.response,
    this.message,
    this.exception,
    this.stackTrace,
  });

  final String? message;
  final SocketResponse? response;
  final Exception? exception;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'SocketException{message: $message,\nresponse: $response,\nexception: $exception,\nstackTrace: $stackTrace}';
  }
}
