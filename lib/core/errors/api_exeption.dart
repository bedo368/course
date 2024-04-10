import 'package:equatable/equatable.dart';

abstract class ApiExpetion extends Equatable implements Exception {
  const ApiExpetion({
    required this.message,
    required this.statusCode,
  });

  factory ApiExpetion.createNewException({
    required dynamic statusCode,
    String? message,
  }) {
    if (statusCode == 100) {
      return const InformationalFailure(message: 'Continue', statusCode: 100);
    } else if (statusCode == 101) {
      return const InformationalFailure(
        message: 'Switching Protocols',
        statusCode: 101,
      );
    } else if (statusCode == 102) {
      return const InformationalFailure(message: 'Processing', statusCode: 102);
    } else if (statusCode == 200) {
      return const SuccessFailure(message: 'OK', statusCode: 200);
    } else if (statusCode == 201) {
      return const SuccessFailure(message: 'Created', statusCode: 201);
    } else if (statusCode == 202) {
      return const SuccessFailure(message: 'Accepted', statusCode: 202);
    } else if (statusCode == 203) {
      return const SuccessFailure(
        message: 'Non-Authoritative Information',
        statusCode: 203,
      );
    } else if (statusCode == 204) {
      return const SuccessFailure(message: 'No Content', statusCode: 204);
    } else if (statusCode == 205) {
      return const SuccessFailure(message: 'Reset Content', statusCode: 205);
    } else if (statusCode == 206) {
      return const SuccessFailure(message: 'Partial Content', statusCode: 206);
    } else if (statusCode == 300) {
      return RedirectionFailure(
        message: message ?? 'Multiple Choices',
        statusCode: 300,
      );
    } else if (statusCode == 301) {
      return RedirectionFailure(
        message: message ?? 'Moved Permanently',
        statusCode: 301,
      );
    } else if (statusCode == 302) {
      return RedirectionFailure(message: message ?? 'Found', statusCode: 302);
    } else if (statusCode == 303) {
      return RedirectionFailure(
        message: message ?? 'See Other',
        statusCode: 303,
      );
    } else if (statusCode == 304) {
      return RedirectionFailure(
        message: message ?? 'Not Modified',
        statusCode: 304,
      );
    } else if (statusCode == 400) {
      return ClientErrorFailure(
        message: message ?? 'Bad Request',
        statusCode: 400,
      );
    } else if (statusCode == 401) {
      return ClientErrorFailure(
        message: message ?? 'Unauthorized',
        statusCode: 401,
      );
    } else if (statusCode == 402) {
      return ClientErrorFailure(
        message: message ?? 'Payment Required',
        statusCode: 402,
      );
    } else if (statusCode == 403) {
      return ClientErrorFailure(
        message: message ?? 'Forbidden',
        statusCode: 403,
      );
    } else if (statusCode == 404) {
      return ClientErrorFailure(
        message: message ?? 'Not Found',
        statusCode: 404,
      );
    } else if (statusCode == 405) {
      return const ClientErrorFailure(
        message: 'Method Not Allowed',
        statusCode: 405,
      );
    } else if (statusCode == 500) {
      return ApiFailure(
        message: message ?? 'Api Error happened ',
        statusCode: 500,
      );
    } else if (statusCode == 501) {
      return ApiErrorFailure(
        message: message ?? 'Not Implemented',
        statusCode: 501,
      );
    } else if (statusCode == 502) {
      return ApiErrorFailure(
        message: message ?? 'Bad Gateway',
        statusCode: 502,
      );
    } else if (statusCode == 503) {
      return ApiErrorFailure(
        message: message ?? 'Service Unavailable',
        statusCode: 503,
      );
    } else if (statusCode == 504) {
      return ApiErrorFailure(
        message: message ?? 'Gateway Timeout',
        statusCode: 504,
      );
    } else if (statusCode == 505) {
      return ApiErrorFailure(
        message: message ?? 'HTTP Version Not Supported',
        statusCode: 505,
      );
    } else {
      return const DefaultApiError();
    }
  }
  final String message;
  final dynamic statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class InformationalFailure extends ApiExpetion {
  const InformationalFailure({
    required super.message,
    required super.statusCode,
  });
}

class SuccessFailure extends ApiExpetion {
  const SuccessFailure({
    required super.message,
    required super.statusCode,
  });
}

class ServerExpiton extends ApiExpetion {
  const ServerExpiton({
    required super.message,
    required super.statusCode,
  });
}

class RedirectionFailure extends ApiExpetion {
  const RedirectionFailure({
    required super.message,
    required super.statusCode,
  });
}

class ClientErrorFailure extends ApiExpetion {
  const ClientErrorFailure({
    required super.message,
    required super.statusCode,
  });
}

class ApiFailure extends ApiExpetion {
  const ApiFailure({
    required super.message,
    required super.statusCode,
  });
}

class ApiErrorFailure extends ApiExpetion {
  const ApiErrorFailure({
    required super.message,
    required super.statusCode,
  });
}

class NoInternetConnectivityFailure extends ApiExpetion {
  const NoInternetConnectivityFailure()
      : super(message: 'No Internet Connectivity', statusCode: -1);
}

class DefaultApiError extends ApiExpetion {
  const DefaultApiError()
      : super(statusCode: 0, message: 'something wrong happened while trying');
}

class ParsingFailure extends ApiExpetion {
  const ParsingFailure(String message)
      : super(message: message, statusCode: 400);
}

class UnAuthorisedFailure extends ApiExpetion {
  const UnAuthorisedFailure()
      : super(message: 'Unauthorized Access', statusCode: 401);
}

class NotFoundFailure extends ApiExpetion {
  const NotFoundFailure() : super(message: 'Not Found', statusCode: 404);
}

class BadRequestFailure extends ApiExpetion {
  const BadRequestFailure(String message)
      : super(message: message, statusCode: 400);
}
