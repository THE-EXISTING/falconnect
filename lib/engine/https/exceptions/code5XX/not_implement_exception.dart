import 'package:falconnect/lib.dart';

class NotImplementException extends NetworkServerErrorException {
  const NotImplementException({
    super.code = 501,
    super.message,
    super.developerMessage,
  });
}
