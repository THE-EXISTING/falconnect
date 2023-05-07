import 'package:falconnect/falconnect.dart';

extension SetupHeader on RequestOptions {
  void setHeaderTokenBearer(String token) {
    headers[HttpHeader.HEADER_AUTHORIZE] = 'Bearer $token';
  }

  void removeHeaderToken() async {
    headers.remove(HttpHeader.HEADER_AUTHORIZE);
  }
}
