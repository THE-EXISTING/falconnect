import 'package:falconnect/lib.dart';
import 'package:falmodel/falmodel.dart';
import 'package:faltool/faltool.dart';

class SocketOperationNotFound extends SocketException {
  const SocketOperationNotFound({
    SocketResponse? response,
    String? message,
    Exception? exception,
    StackTrace? stackTrace,
  }) : super(
          response: response,
          message: message ?? 'Operation not match',
          exception: exception,
          stackTrace: stackTrace,
        );
}
