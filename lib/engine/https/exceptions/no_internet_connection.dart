import 'package:falconnect/falconnect.dart';

class NoInternetConnectionException extends NetworkException {
  const NoInternetConnectionException(
      {required String service,
      int code = 0,
      String message = 'No internet connection.'})
      : super(service: service, code: code, message: message);
}
