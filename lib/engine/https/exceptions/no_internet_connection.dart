import 'package:falconnect/lib.dart';

class NoInternetConnectionException extends NetworkException {
  const NoInternetConnectionException(
      {required String service,
      int code = 0,
      String message = 'No internet connection.'})
      : super(developerMessage: service, code: code, message: message);
}
