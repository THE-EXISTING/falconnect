// ignore_for_file: constant_identifier_names

import 'package:falconnect/lib.dart';

class DatasourceBoundState<EntityType, ResponseType> {
  DatasourceBoundState._();

  static const String TAG = 'DatasourceBoundState';

  static Stream<Either<Failure, EntityType>> asLocalStream<EntityType>({
    required Future<EntityType> Function() loadFromDbFuture,
  }) async* {
    EntityType dataFromDb = await loadFromDbFuture();
    NLog.i(TAG, 'Success load data from database');
    yield Right(dataFromDb);
  }

  ///
  /// - [error] callback use for see the error but not handle it.
  ///   If you want to handle please use [handleError].
  /// - When you implement [handleError] callback the default Failure will not send to stream.
  ///
  static Stream<Either<Failure, EntityType>>
      asRemoteStream<ResponseType, EntityType>({
    required Future<ResponseType> Function() createCallFuture,
    FutureOr<EntityType> Function(ResponseType response)? processResponse,
    Failure Function(dynamic error, StackTrace stacktrace)? handleError,
    Function? error,
  }) async* {
    assert(
      ResponseType == EntityType ||
          (!(ResponseType == EntityType) && processResponse != null),
      'You need to specify the `processResponse` when the EntityType and ResponseType types are different',
    );

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

      yield Right(data);
    } catch (exception, stackTrace) {
      try {
        error?.call(exception, stackTrace);
      } catch (newException, stackTrace) {
        if (newException is Failure) {
          yield Left(newException);
        } else if (newException is Exception) {
          yield Left(Failure(
            message: newException.toString(),
            exception: newException,
            stacktrace: stackTrace,
          ));
        }
        return;
      }
      NLog.e(TAG, 'Fetching failed', exception);

      yield handleError != null
          ? Left(handleError.call(exception, stackTrace))
          : Left(Failure(
              message: exception.toString(),
              exception: exception,
              stacktrace: stackTrace,
            ));
    }
  }

  ///
  /// - [error] callback use for see the error but not handle it.
  ///   If you want to handle please use [handleError].
  /// - When you implement [handleError] callback the default Failure will not send to stream.
  ///
  static Stream<Either<Failure, EntityType>>
      asStream<ResponseType, EntityType>({
    Future<EntityType> Function()? loadFromDbFuture,
    bool Function(EntityType? data)? shouldFetch,
    Future<ResponseType> Function()? createCallFuture,
    FutureOr<EntityType> Function(ResponseType response)? processResponse,
    Future? Function(EntityType entity)? saveCallResult,
    Failure Function(dynamic error, StackTrace stacktrace)? handleError,
    Function? error,
  }) async* {
    assert(
      ResponseType == EntityType ||
          (!(ResponseType == EntityType) && processResponse != null),
      'You need to specify the `processResponse` when the EntityType and ResponseType types are different',
    );

    ///========================= INNER METHOD =========================///
    Stream<Either<Failure, EntityType>> fetchData() async* {
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
          yield Right(data);
        } catch (exception, stackTrace) {
          try {
            error?.call(exception, stackTrace);
          } catch (newException, stackTrace) {
            if (newException is Failure) {
              yield Left(newException);
            } else if (newException is Exception) {
              yield Left(Failure(
                message: newException.toString(),
                exception: newException,
                stacktrace: stackTrace,
              ));
            }
            return;
          }
          NLog.e(TAG, 'Fetching failed', exception);

          yield handleError != null
              ? Left(handleError.call(exception, stackTrace))
              : Left(Failure(
                  message: exception.toString(),
                  exception: exception,
                  stacktrace: stackTrace,
                ));
        }
        return;
      }
    }

    ///========================= END INNER =========================///
    if (loadFromDbFuture != null && createCallFuture != null) {
      EntityType dataFromDb = await loadFromDbFuture();
      NLog.i(TAG, 'Success load data from database');
      if (shouldFetch != null && shouldFetch(dataFromDb)) {
        NLog.i(TAG, 'Loading... data from network');
        yield Right(dataFromDb);
        yield* fetchData();
      } else {
        NLog.i(TAG, 'Fetching data its not necessary');
        yield Right(dataFromDb);
      }
    } else if (loadFromDbFuture != null) {
      EntityType dataFromDb = await loadFromDbFuture();
      NLog.i(TAG, 'Success load data from database');
      yield Right(dataFromDb);
    } else if (createCallFuture != null) {
      NLog.i(TAG, 'Loading... data from network');
      yield* fetchData();
    } else {
      throw UnimplementedError(
          'Please implement loadFromDbFuture or createCallFuture');
    }
  }
}
