import 'package:client_152022047/styles.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client_152022047/api/local_api.dart';

class KalenderAkademikClient {
  // Get all data
  Future<List<dynamic>> getAllKalenders() async {
    final response = await http.get(Uri.parse('${LocalApi.baseUrl}/table/kalenders'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class KalenderAkademikClientPage extends StatefulWidget {
  @override
  _KalenderAkademikClientPageState createState() =>
      _KalenderAkademikClientPageState();
}

class _KalenderAkademikClientPageState
    extends State<KalenderAkademikClientPage> {
  late Future<List<dynamic>> _kalenders;
  final KalenderAkademikClient _kalenderApi = KalenderAkademikClient();

  @override
  void initState() {
    super.initState();
    _kalenders = _kalenderApi.getAllKalenders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalender Akademik',
          style: TextStyle(color: AppColors.softBeige), // Warna teks AppBar
        ),
        backgroundColor: AppColors.royalBlue, // Warna latar AppBar
        iconTheme:
            IconThemeData(color: AppColors.softBeige), // Warna ikon AppBar
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _kalenders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data kalender akademik.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final kalender = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (kalender['url'] != null)
                        Image.network(
                          kalender['url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Gambar tidak dapat dimuat',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ListTile(
                        title: Text(kalender['tahun_ajaran']),
                        // subtitle: Text(kalender['url']),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
