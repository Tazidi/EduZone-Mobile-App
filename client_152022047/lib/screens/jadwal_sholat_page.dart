import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:client_152022047/styles.dart';

class PrayerTimesPage extends StatefulWidget {
  @override
  _PrayerTimesPageState createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  Map<String, String>? prayerTimes;

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/lakuapik/jadwalsholatorg/master/adzan/bandung/2025/01.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final today = DateTime.now();
        final todayString =
            "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
        final todayData = data.firstWhere(
            (item) => item['tanggal'] == todayString,
            orElse: () => null);

        if (todayData != null) {
          setState(() {
            prayerTimes = {
              "tanggal": todayData['tanggal'],
              "shubuh": todayData['shubuh'],
              "dzuhur": todayData['dzuhur'],
              "ashr": todayData['ashr'],
              "magrib": todayData['magrib'],
              "isya": todayData['isya'],
            };
          });
        } else {
          setState(() {
            prayerTimes = {"error": "Jadwal untuk hari ini tidak ditemukan."};
          });
        }
      } else {
        setState(() {
          prayerTimes = {"error": "Gagal memuat data. Coba lagi nanti."};
        });
      }
    } catch (e) {
      setState(() {
        prayerTimes = {"error": "Terjadi kesalahan: $e"};
      });
    }
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final String formattedDate =
          DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(parsedDate);
      return formattedDate;
    } catch (e) {
      return date; // Jika parsing gagal, kembalikan tanggal asli
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jadwal Sholat Hari Ini',
          style:
              TextStyle(color: AppColors.softBeige), // Teks berwarna softBeige
        ),
        backgroundColor: AppColors.royalBlue, // Header royalBlue
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue, // Latar belakang skyBlue
        padding: EdgeInsets.all(16),
        child: prayerTimes == null
            ? Center(child: CircularProgressIndicator())
            : prayerTimes!.containsKey("error")
                ? Center(
                    child: Text(
                      prayerTimes!["error"] ?? "Error",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Mulai dari atas
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Pusatkan horizontal
                    children: [
                      SizedBox(height: 40), // Jarak dari atas layar
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        color: AppColors.powderBlue, // Card warna powderBlue
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatDate(prayerTimes!['tanggal']!),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors
                                      .royalBlue, // Teks tanggal royalBlue
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Divider(color: AppColors.royalBlue),
                              _buildPrayerTimeRow(
                                  "Shubuh", prayerTimes!['shubuh']!),
                              _buildPrayerTimeRow(
                                  "Dzuhur", prayerTimes!['dzuhur']!),
                              _buildPrayerTimeRow(
                                  "Ashar", prayerTimes!['ashr']!),
                              _buildPrayerTimeRow(
                                  "Magrib", prayerTimes!['magrib']!),
                              _buildPrayerTimeRow(
                                  "Isya", prayerTimes!['isya']!),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.royalBlue, // Warna teks nama waktu
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.royalBlue, // Warna teks waktu sholat
            ),
          ),
        ],
      ),
    );
  }
}
