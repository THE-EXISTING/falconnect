import 'package:falconnect/falconnect.dart';
import 'package:falmodel/falmodel.dart';
import 'package:faltool/faltool.dart';

class SocketRetryException extends SocketException {
  const SocketRetryException({
    required this.retryCount,
    SocketResponseX? response,
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
