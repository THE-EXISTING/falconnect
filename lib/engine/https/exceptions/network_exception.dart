class NetworkException implements Exception {
  final int code;
  final String? message;
  final String? developerMessage;

  const NetworkException({
    this.code = 0,
    this.message,
    this.developerMessage,
  });

  @override
  String toString() {
    String msg = '';

    if (code != 0) msg += '>>Code: $code';

    if (message != null && message!.isNotEmpty) {
      msg += ' | Exception: $message';
    }
    if (developerMessage != null && developerMessage!.isNotEmpty) {
      msg += '[$developerMessage]\n';
    }

    return msg;
  }
}
