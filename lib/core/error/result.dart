import 'failure.dart';

class Result<T> {
  final T? data;
  final Failure? failure;

  const Result.success(this.data) : failure = null;
  const Result.error(this.failure) : data = null;

  bool get isSuccess => data != null;
}
