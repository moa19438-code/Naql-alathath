class AppError {
  final String message;
  final String? code;
  final Object? cause;

  const AppError(this.message, {this.code, this.cause});

  @override
  String toString() => 'AppError(message: $message, code: $code, cause: $cause)';
}
