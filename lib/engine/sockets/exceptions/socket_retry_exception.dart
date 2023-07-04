import 'package:falconnect/lib.dart';
import 'package:falmodel/falmodel.dart';
import 'package:faltool/faltool.dart';

class SocketRetryException extends SocketException {
  const SocketRetryException({
    required this.retryCount,
    SocketResponse? response,
    String? message,
    Exception? exception,
    StackTrace? stackTrace,
  }) : super(
          response: response,
          exception: exception,
          stackTrace: stackTrace,
          message: message ?? 'Retry request at $retryCount',
        );

  final int retryCount;
}
