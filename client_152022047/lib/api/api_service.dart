import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api-sekolah-indonesia.vercel.app';

  Future<List<dynamic>> searchSchool(String schoolName) async {
    final encodedSchoolName = Uri.encodeQueryComponent(schoolName.trim());
    final String url = '$baseUrl/sekolah/s?sekolah=$encodedSchoolName';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Debug log respons API
        print('Response Body: $body');

        // Memeriksa apakah key 'dataSekolah' ada dan valid
        if (body is Map && body.containsKey('dataSekolah') && body['dataSekolah'] is List) {
          return body['dataSekolah'];
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
