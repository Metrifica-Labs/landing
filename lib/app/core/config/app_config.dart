class AppConfig {
  AppConfig._();

  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.metrifica.com.br/landing',
  );
}
