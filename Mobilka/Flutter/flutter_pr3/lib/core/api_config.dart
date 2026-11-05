class ApiConfig {
  ApiConfig._();

  static const baseUrl = 'https://api.api-ninjas.com/v1/';
  static const apiKey = String.fromEnvironment(
    'API_NINJAS_KEY',
    defaultValue: 'VLNMGe0ETSF4CxbSV45bONWKVAQoTByWsLeKqes7',
  );
}
