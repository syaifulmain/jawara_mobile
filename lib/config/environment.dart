class Environment {
  // Base URL Laravel API
  // GANTI dengan IP/URL server Laravel Anda
  // Untuk Android Emulator: http://10.0.2.2:8000
  // Untuk iOS Simulator: http://127.0.0.1:8000
  // Untuk Physical Device: http://192.168.x.x:8000 (IP komputer Anda)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost/api',
  );
}