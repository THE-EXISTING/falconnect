import 'package:falconnect/falconnect.dart';
import 'package:falmodel/falmodel.dart';
import 'package:faltool/faltool.dart';

class SocketOperationNotFound extends SocketException {
  const SocketOperationNotFound({
    SocketResponseX? response,
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
