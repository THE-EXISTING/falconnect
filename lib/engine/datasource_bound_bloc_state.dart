// ignore_for_file: constant_identifier_names

import 'package:falconnect/lib.dart';

class DatasourceBoundBlocState<EntityType, ResponseType> {
  DatasourceBoundBlocState._();

  static const String TAG = 'DatasourceBoundBlocState';

  static Stream<BlocState<EntityType>> asStream<EntityType, ResponseType>({
    Future<EntityType> Function()? loadFromDbFuture,
    bool Function(EntityType? data)? shouldFetch,
    Future<ResponseType> Function()? createCallFuture,
    FutureOr<EntityType> Function(ResponseType response)? processResponse,
    Future? Function(EntityType item)? saveCallResult,
    Function? error,
  }) async* {
    assert(
      ResponseType == EntityType ||
          (!(ResponseType == EntityType) && processResponse != null),
      'You need to specify the `processResponse` when the EntityType and ResponseType types are different',
    );
    ///========================= INNER METHOD =========================///
    Stream<BlocState<EntityType>> fetchData() async* {
      if (createCallFuture != null) {
        try {
          final ResponseType response = await createCallFuture();
          NLog.i(TAG, 'Success fetch data');

          late EntityType data;
          if (processResponse != null) {
            final EntityType processedData = await processResponse(response);
            data = processedData;
          } else {
            final EntityType castData = response as EntityType;
            data = castData;
          }

          if (saveCallResult != null) {
            await saveCallResult(data);
            NLog.i(TAG, 'Success save result data');
          }
          yield BlocState.success(data: data);
        } catch (exception, stackTrace) {
          try {
            error?.call(exception, stackTrace);
          } catch (newException, stackTrace) {
            if (newException is Exception) {
              yield BlocState.fail(
                  data: null, error: newException, stackTrace: stackTrace);
              return;
            }
          }
          NLog.e(TAG, 'Fetching failed', exception);
          yield BlocState.fail(
              data: null, error: exception, stackTrace: stackTrace);
        }
        return;
      }
    }
    ///========================= END INNER =========================///
    yield BlocState.loading();
    if (loadFromDbFuture != null && createCallFuture != null) {
      EntityType dataFromDb = await loadFromDbFuture();
      NLog.i(TAG, 'Success load data from database');
      if (shouldFetch != null && shouldFetch(dataFromDb)) {
        NLog.i(TAG, 'Loading... with data from database');
        yield BlocState.loading(data: dataFromDb);
        yield* fetchData();
      } else {
        NLog.i(TAG, 'Fetching data its not necessary');
        yield BlocState.success(data: dataFromDb);
      }
    } else if (loadFromDbFuture != null) {
      EntityType dataFromDb = await loadFromDbFuture();
      NLog.i(TAG, 'Success load data from database');
      yield BlocState.success(data: dataFromDb);
    } else if (createCallFuture != null) {
      NLog.i(TAG, 'Loading...');
      yield* fetchData();
    } else {
      throw UnimplementedError(
          'Please implement loadFromDbFuture or createCallFuture');
    }
  }
}
