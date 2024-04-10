import 'package:course_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

typedef FutureResult<T> = Future<Either<Failure, T>>;

typedef DataMap = Map<String, dynamic>;
