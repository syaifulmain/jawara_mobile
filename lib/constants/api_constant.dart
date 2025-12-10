import '../config/environment.dart';

class ApiConstants {
  static const String baseUrl = Environment.baseUrl;

  // Auth endpoints
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String profile = '$baseUrl/profile';

  // activities endpoints
  static const String activities = '$baseUrl/activities';
  static const String activityThisMonth = '$baseUrl/activities-this-month';
  // broadcast endpoints
  static const String broadcasts = '$baseUrl/broadcasts';
  static const String broadcastThisWeek = '$baseUrl/broadcast-this-week';
  // static String broadcastsDownloadPhoto(String id) => '$baseUrl/broadcasts/$id/download-photo';
  // static String broadcastsDownloadDocument(String id) => '$baseUrl/broadcasts/$id/download-document';

  static const String residents = '$baseUrl/residents';
  static const String families = '$baseUrl/families';
  static const String addresses = '$baseUrl/addresses';
  static const String users = '$baseUrl/users';
  static const String categories = '$baseUrl/income-categories';
  static const String incomes = '$baseUrl/incomes';
  static const String transferChannels = '$baseUrl/transfer-channels';

  static const String pengeluaran = '$baseUrl/pengeluaran';
  static const String bills = '$baseUrl/bills';
  static const String userFamily = '$baseUrl/user/family';

  static const String dashboardKeuangan = '$baseUrl/dashboard/keuangan';
  static const String dashboardKegiatan = '$baseUrl/dashboard/kegiatan';
  static const String dashboardKependudukan = '$baseUrl/dashboard/kependudukan';
  static const String financialReport = '$baseUrl/reports/financial';


  // Helper untuk single todo
  // static String todoById(int id) => '$baseUrl/todos/$id';
}
