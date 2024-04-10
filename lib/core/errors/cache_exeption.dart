import 'package:equatable/equatable.dart';

abstract class CacheException extends Equatable implements Exception {
  const CacheException({
    required this.message,
  });

  factory CacheException.createNewException({String? message}) {
    return DefaultCacheError(message: message ?? 'Cache error occurred');
  }

  final String message;

  @override
  List<Object?> get props => [message];
}

class DefaultCacheError extends CacheException {
  const DefaultCacheError({required super.message});
}
