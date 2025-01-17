import 'package:admin_152022047/api/local_api.dart';
import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GrafikKelasSiswa extends StatefulWidget {
  @override
  _GrafikKelasSiswaState createState() => _GrafikKelasSiswaState();
}

class _GrafikKelasSiswaState extends State<GrafikKelasSiswa> {
  late Future<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final url = Uri.parse("${LocalApi.baseUrl}/table/users");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      Map<String, int> kelasCount = {};

      for (var item in jsonData) {
        String kelas = item['kelas'];
        kelasCount[kelas] = (kelasCount[kelas] ?? 0) + 1;
      }

      return {
        'kelasCount': kelasCount,
        'totalUsers': jsonData.length,
      };
    } else {
      return {
        'kelasCount': {},
        'totalUsers': 0,
      }; // Pastikan data tidak null jika gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grafik Kelas Siswa'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data'));
          } else {
            Map<String, int> kelasCount = snapshot.data!['kelasCount'];
            int totalUsers = snapshot.data!['totalUsers'];
            List<OrdinalData> chartData = kelasCount.entries
                .map((e) =>
                    OrdinalData(domain: 'Kelas ${e.key}', measure: e.value))
                .toList();

            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  'Jumlah Siswa: $totalUsers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartBarO(
                    groupList: [
                      OrdinalGroup(
                        id: 'Jumlah Siswa',
                        data: chartData,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
