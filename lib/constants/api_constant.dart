class ApiConstants {
  // Base URL Laravel API
  // GANTI dengan IP/URL server Laravel Anda
  // Untuk Android Emulator: http://10.0.2.2:8000
  // Untuk iOS Simulator: http://127.0.0.1:8000
  // Untuk Physical Device: http://192.168.x.x:8000 (IP komputer Anda)
  // static const String baseUrl = 'http://192.168.1.201:8000/api';
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Auth endpoints
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String profile = '$baseUrl/profile';

  // activities endpoints
  static const String activities = '$baseUrl/activities';
  // broadcast endpoints
  static const String broadcasts = '$baseUrl/broadcasts';
  // static String broadcastsDownloadPhoto(String id) => '$baseUrl/broadcasts/$id/download-photo';
  // static String broadcastsDownloadDocument(String id) => '$baseUrl/broadcasts/$id/download-document';

  static const String residents = '$baseUrl/residents';
  static const String families = '$baseUrl/families';
  static const String addresses = '$baseUrl/addresses';
  static const String users = '$baseUrl/users';
  static const String transferChannels = '$baseUrl/transfer-channels';



  // Helper untuk single todo
  // static String todoById(int id) => '$baseUrl/todos/$id';
}