sealed class AppError {
  final String message;
  const AppError(this.message);
}

class UnknownError extends AppError {
  const UnknownError([super.message = 'An unknown error occurred']);
}

class NetworkError extends AppError {
  const NetworkError([super.message = 'Network error. Please try again.']);
}
