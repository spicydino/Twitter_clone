import 'package:fpdart/fpdart.dart';
import 'package:mns_final/core/core.dart';


typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
