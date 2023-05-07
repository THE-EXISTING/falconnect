import 'package:equatable/equatable.dart';

/// NOTE: Please implement factory method to every sub classes.
///
/// factory YourBody.fromJsonStr(String data) =>
///     YourBody.fromJson(json.decode(data));
///
/// factory YourBody.fromJson(Map<String, Object> json) {
///   return YourBody(
///     ...
///   );
/// }
abstract class BaseRequest with EquatableMixin {
  const BaseRequest();


  @override
  bool get stringify => true;
}
