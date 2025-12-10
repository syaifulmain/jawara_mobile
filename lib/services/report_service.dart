import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../constants/api_constant.dart';
import 'api_exception.dart';

class ReportService {
  Future<void> downloadFinancialReportPdf(
      String token, {
        DateTime? startDate,
        DateTime? endDate,
      }) async {
    try {
      String url = ApiConstants.financialReportDownloadPdf;
      List<String> queryParams = [];

      if (startDate != null) {
        queryParams.add('start_date=${startDate.toIso8601String().split('T')[0]}');
      }
      if (endDate != null) {
        queryParams.add('end_date=${endDate.toIso8601String().split('T')[0]}');
      }
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'laporan_keuangan_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(response.bodyBytes);
        await OpenFile.open(file.path);
      } else {
        throw ApiException(
          'Failed to download PDF (${response.statusCode})',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
