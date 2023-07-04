// ignore_for_file: constant_identifier_names

import 'package:falconnect/lib.dart';

class SocketBoundResource<EntityType, ResponseType> {
  SocketBoundResource._();

  static const String TAG = 'SocketBoundResource';

  static Stream<BlocState<EntityType>> asStream<EntityType, ResponseType>({
    bool Function(EntityType? data)? whenSave,
    required Stream<ResponseType> Function() createCallStream,
    FutureOr<EntityType> Function(ResponseType result)? processResponse,
    Future Function(EntityType item)? saveCallResult,
    Function? error,
  }) {
    assert(
      ResponseType == EntityType ||
          (!(ResponseType == EntityType) && processResponse != null),
      'You need to specify the `processResponse` when the EntityType and ResponseType types are different',
    );

    // Start: inner function
    void onHandleException(Object exception, StackTrace? stackTrace, EventSink<BlocState<EntityType>> sink){
      if (exception is Exception) {
        try {
          error?.call(exception, stackTrace);
        } on Exception catch (newException) {
          sink.add(BlocState.fail(
              data: null, error: newException, stackTrace: stackTrace));
          return;
        }
        NLog.e(TAG, 'Operation failed', exception);
        sink.add(BlocState.fail(
            data: null, error: exception, stackTrace: stackTrace));
      }
    }
    // End: inner function

    return createCallStream().transform(
        StreamTransformer<ResponseType, BlocState<EntityType>>.fromHandlers(
      handleData: (ResponseType response, sink) async {
        try {
          late EntityType data;
          if (processResponse != null) {
            final EntityType processedData = await processResponse(response);
            data = processedData;
          } else {
            final EntityType castData = response as EntityType;
            data = castData;
          }

          if (whenSave?.call(data) == true && saveCallResult != null) {
            await saveCallResult(data);
            NLog.i(TAG, 'Success save result data');
          }
          sink.add(BlocState.success(data: data));
        } on Exception catch (exception, stackTrace) {
          onHandleException(exception, stackTrace, sink);
        }
      },
      handleError: (exception, stackTrace, sink) {
        onHandleException(exception, stackTrace, sink);
      },
      handleDone: (sink) {
        sink.close();
      },
    ));
  }
}
