import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  // Fungsi untuk mencari lokasi berdasarkan nama sekolah menggunakan API eksternal
  Future<Map<String, dynamic>> searchSchoolByName(String schoolName) async {
    final Uri url = Uri.parse('https://api-sekolah-indonesia.vercel.app/sekolah/s?sekolah=$schoolName');
    
    try {
      // Kirim request ke API
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse hasil response JSON
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      // Jika terjadi kesalahan
      throw Exception('Error: $e');
    }
  }
}
