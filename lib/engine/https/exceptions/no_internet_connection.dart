import 'package:falconnect/lib.dart';

class NoInternetConnectionException extends NetworkException {
  const NoInternetConnectionException({
    super.code,
    super.message = 'No internet connection.',
    super.developerMessage,
    super.errors,
  });
}
