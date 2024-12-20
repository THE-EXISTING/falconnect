class NetworkException implements Exception {
  const NetworkException({
    this.code = 0,
    this.message,
    this.developerMessage,
    this.errors,
  });

  final int code;
  final String? message;
  final String? developerMessage;
  final List<Exception>? errors;

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

    errors?.forEach(
      (error) => msg += '   ${error.toString()}]\n',
    );

    return msg;
  }
}
