import 'dart:io';

import 'package:course_app/core/errors/api_exeption.dart';
import 'package:course_app/core/errors/cache_exeption.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.statusCode,
  });

  factory Failure.createNewFailure({required dynamic error}) {
    if (error is Failure) {
      return error;
    } else if (error is ApiExpetion) {
      return ServerFailure.fromException(error);
    } else if (error is SocketException) {
      return const NoInternetConnectivityFailure();
    } else if (error is FormatException) {
      return ParsingFailure(error.message);
    } else if (error is HttpException) {
      return const UnAuthorisedFailure();
    } else if (error is PathNotFoundException) {
      return const NotFoundFailure();
    } else if (error is CacheException) {
      return CacheFailure(message: error.toString(), statusCode: 500);
    } else {
      return const DefaultError();
    }
  }
  final String message;
  final dynamic statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ApiExpetion apiExpetion)
      : this(message: apiExpetion.message, statusCode: apiExpetion.statusCode);
}

class TypeFailure extends Failure {
  const TypeFailure({required super.message, required super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, required super.statusCode});
}

class CashFailure extends Failure {
  const CashFailure({required super.message, required super.statusCode});
}

class NoInternetConnectivityFailure extends Failure {
  const NoInternetConnectivityFailure()
      : super(message: 'No Internet Connectivity', statusCode: -1);
}

class DefaultError extends Failure {
  const DefaultError()
      : super(statusCode: 0, message: 'something wrong happen while trying ');
}

class ParsingFailure extends Failure {
  const ParsingFailure(String message)
      : super(message: message, statusCode: 400);
}

class UnAuthorisedFailure extends Failure {
  const UnAuthorisedFailure()
      : super(message: 'Unauthorized Access', statusCode: 401);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super(message: 'Not Found', statusCode: 404);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(String message)
      : super(message: message, statusCode: 400);
}
