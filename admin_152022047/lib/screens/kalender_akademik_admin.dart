import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_152022047/styles.dart'; // Import AppColors
import 'package:admin_152022047/api/local_api.dart'; // Import LocalApi

class KalenderAkademikAdmin {
  // Get all data
  Future<List<dynamic>> getAllKalenders() async {
    final response =
        await http.get(Uri.parse('${LocalApi.baseUrl}/table/kalenders'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Create new data
  Future<Map<String, dynamic>> createKalender(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${LocalApi.baseUrl}/api/kalenders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create data');
    }
  }

  // Update existing data
  Future<Map<String, dynamic>> updateKalender(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('${LocalApi.baseUrl}/api/kalenders/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data');
    }
  }

  // Delete data
  Future<void> deleteKalender(String id) async {
    final response =
        await http.delete(Uri.parse('${LocalApi.baseUrl}/api/kalenders/$id'));
    if (response.statusCode == 200) {
      print('Data deleted successfully');
    } else {
      throw Exception('Failed to delete data');
    }
  }
}

class KalenderAkademikAdminPage extends StatefulWidget {
  @override
  _KalenderAkademikAdminPageState createState() =>
      _KalenderAkademikAdminPageState();
}

class _KalenderAkademikAdminPageState extends State<KalenderAkademikAdminPage> {
  late Future<List<dynamic>> _kalenders;
  final KalenderAkademikAdmin _kalenderApi = KalenderAkademikAdmin();

  @override
  void initState() {
    super.initState();
    _kalenders = _kalenderApi.getAllKalenders();
  }

  void showForm({Map<String, dynamic>? kalender}) {
    final _tahunAjaranController = TextEditingController();
    final _urlController = TextEditingController();

    if (kalender != null) {
      _tahunAjaranController.text = kalender['tahun_ajaran'];
      _urlController.text = kalender['url'];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.skyBlue,
        title: Text(
          kalender == null ? 'Tambah Kalender' : 'Edit Kalender',
          style: TextStyle(color: AppColors.royalBlue),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tahunAjaranController,
              decoration: InputDecoration(
                labelText: 'Tahun Ajaran',
                labelStyle: TextStyle(color: AppColors.royalBlue),
              ),
            ),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL Kalender',
                labelStyle: TextStyle(color: AppColors.royalBlue),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: AppColors.royalBlue),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.powderBlue,
            ),
            onPressed: () async {
              try {
                final data = {
                  'tahun_ajaran': _tahunAjaranController.text,
                  'url': _urlController.text,
                };

                if (kalender == null) {
                  await _kalenderApi.createKalender(data);
                } else {
                  await _kalenderApi.updateKalender(
                      kalender['id'].toString(), data);
                }

                setState(() {
                  _kalenders = _kalenderApi.getAllKalenders();
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data berhasil disimpan!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelola Kalender Akademik',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue,
        child: FutureBuilder<List<dynamic>>(
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
                    color: AppColors.powderBlue,
                    child: ListTile(
                      title: Text(
                        kalender['tahun_ajaran'],
                        style: TextStyle(color: AppColors.royalBlue),
                      ),
                      subtitle: Text(
                        kalender['url'],
                        style: TextStyle(color: AppColors.royalBlue),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: AppColors.royalBlue),
                            onPressed: () {
                              showForm(kalender: kalender);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              try {
                                await _kalenderApi
                                    .deleteKalender(kalender['id'].toString());
                                setState(() {
                                  _kalenders = _kalenderApi.getAllKalenders();
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Gagal menghapus data: $e')),
                                );
                              }
                            },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        backgroundColor: AppColors.royalBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
