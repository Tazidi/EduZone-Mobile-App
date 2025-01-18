import 'package:client_152022047/screens/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:client_152022047/styles.dart';
import 'package:client_152022047/api/local_api.dart'; // Import LocalApi
import 'package:url_launcher/url_launcher.dart';

class SoalBOSApi {
  // Get all data
  Future<List<dynamic>> getAllSoalBOS() async {
    final response =
        await http.get(Uri.parse('${LocalApi.baseUrl}/table/soal_bos'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class SoalBOSClientPage extends StatefulWidget {
  @override
  _SoalBOSClientPageState createState() => _SoalBOSClientPageState();
}

class _SoalBOSClientPageState extends State<SoalBOSClientPage> {
  late Future<List<dynamic>> _soalBOSList;
  final SoalBOSApi _soalBOSApi = SoalBOSApi();

  @override
  void initState() {
    super.initState();
    _soalBOSList = _soalBOSApi.getAllSoalBOS();
  }

  Future<void> _openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Soal BOS',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue,
        padding: EdgeInsets.all(12),
        child: FutureBuilder<List<dynamic>>(
          future: _soalBOSList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada data soal BOS.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.royalBlue,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final soalBOS = snapshot.data![index];
                  return Card(
                    color: AppColors.powderBlue,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            soalBOS['nama'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.royalBlue,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Jenis: ${soalBOS['jenis']}',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerPage(
                                        pdfUrl: soalBOS['url'],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.royalBlue,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: Text(
                                  'Open PDF Viewer',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _openInBrowser(soalBOS['url']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: Text(
                                  'Open in Browser',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
