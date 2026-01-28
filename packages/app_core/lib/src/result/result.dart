import 'app_error.dart';

sealed class Result<T> {
  const Result();
  R when<R>({required R Function(T) ok, required R Function(AppError) err});
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);

  @override
  R when<R>({required R Function(T) ok, required R Function(AppError) err}) => ok(value);
}

class Err<T> extends Result<T> {
  final AppError error;
  const Err(this.error);

  @override
  R when<R>({required R Function(T) ok, required R Function(AppError) err}) => err(error);
}
