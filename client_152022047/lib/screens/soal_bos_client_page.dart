import 'package:client_152022047/screens/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:client_152022047/styles.dart';
import 'package:client_152022047/api/local_api.dart'; // Import LocalApi

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Card(
                color: AppColors.powderBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Instruksi:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.royalBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tekan untuk membuka PDF.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Tekan dan tahan untuk menyalin link PDF.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
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
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              soalBOS['nama'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.royalBlue,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jenis: ${soalBOS['jenis']}',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFViewerPage(
                                          pdfUrl: soalBOS['url'],
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    Clipboard.setData(
                                        ClipboardData(text: soalBOS['url']));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('URL disalin ke clipboard')),
                                    );
                                  },
                                  child: Text(
                                    soalBOS['url'],
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 16, 29, 41),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                    ),
                                  ),
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
          ],
        ),
      ),
    );
  }
}
