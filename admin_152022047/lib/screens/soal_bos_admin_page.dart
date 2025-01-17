import 'package:admin_152022047/styles.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_152022047/api/local_api.dart'; // Import LocalApi

class SoalBOSApi {
  Future<List<dynamic>> getAllSoalBOS() async {
    final response =
        await http.get(Uri.parse('${LocalApi.baseUrl}/table/soal_bos'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> createSoalBOS(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${LocalApi.baseUrl}/api/soal_bos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create data');
    }
  }

  Future<Map<String, dynamic>> updateSoalBOS(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('${LocalApi.baseUrl}/api/soal_bos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteSoalBOS(String id) async {
    final response =
        await http.delete(Uri.parse('${LocalApi.baseUrl}/api/soal_bos/$id'));
    if (response.statusCode == 200) {
      print('Data deleted successfully');
    } else {
      throw Exception('Failed to delete data');
    }
  }
}

class SoalBOSAdminPage extends StatefulWidget {
  @override
  _SoalBOSAdminPageState createState() => _SoalBOSAdminPageState();
}

class _SoalBOSAdminPageState extends State<SoalBOSAdminPage> {
  late Future<List<dynamic>> _soalBOSList;
  final SoalBOSApi _soalBOSApi = SoalBOSApi();

  @override
  void initState() {
    super.initState();
    _soalBOSList = _soalBOSApi.getAllSoalBOS();
  }

  void showForm({Map<String, dynamic>? soalBOS}) {
    final _namaController = TextEditingController();
    final _urlController = TextEditingController();
    String? _selectedJenis;

    if (soalBOS != null) {
      _namaController.text = soalBOS['nama'];
      _selectedJenis = soalBOS['jenis'];
      _urlController.text = soalBOS['url'];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.skyBlue,
        title: Text(
          soalBOS == null ? 'Tambah Soal BOS' : 'Edit Soal BOS',
          style: TextStyle(color: AppColors.royalBlue),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Buku / Soal',
                labelStyle: TextStyle(color: AppColors.royalBlue),
                filled: true,
                fillColor: AppColors.powderBlue,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.royalBlue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.softBeige),
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedJenis,
              items: ['Buku', 'Soal']
                  .map((jenis) => DropdownMenuItem(
                        value: jenis,
                        child: Text(jenis,
                            style: TextStyle(color: AppColors.royalBlue)),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Jenis',
                labelStyle: TextStyle(color: AppColors.royalBlue),
                filled: true,
                fillColor: AppColors.powderBlue,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.royalBlue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.softBeige),
                ),
              ),
              onChanged: (value) {
                _selectedJenis = value;
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL Soal',
                labelStyle: TextStyle(color: AppColors.royalBlue),
                filled: true,
                fillColor: AppColors.powderBlue,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.royalBlue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.softBeige),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: AppColors.royalBlue)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.royalBlue, // Warna latar belakang tombol
              foregroundColor: AppColors.softBeige, // Warna teks tombol
            ),
            onPressed: () async {
              try {
                final data = {
                  'nama': _namaController.text,
                  'jenis': _selectedJenis,
                  'url': _urlController.text,
                };

                if (soalBOS == null) {
                  await _soalBOSApi.createSoalBOS(data);
                } else {
                  await _soalBOSApi.updateSoalBOS(
                      soalBOS['id'].toString(), data);
                }

                setState(() {
                  _soalBOSList = _soalBOSApi.getAllSoalBOS();
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
          'Kelola Soal & Buku BOS',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue,
        child: FutureBuilder<List<dynamic>>(
          future: _soalBOSList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Tidak ada data soal BOS.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final soalBOS = snapshot.data![index];
                  return Card(
                    color: AppColors.powderBlue,
                    child: ListTile(
                      title: Text(
                        soalBOS['nama'],
                        style: TextStyle(color: AppColors.royalBlue),
                      ),
                      subtitle: Text(
                        soalBOS['jenis'],
                        style: TextStyle(color: AppColors.royalBlue),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: AppColors.royalBlue),
                            onPressed: () {
                              showForm(soalBOS: soalBOS);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: AppColors.gingerbread),
                            onPressed: () async {
                              try {
                                await _soalBOSApi
                                    .deleteSoalBOS(soalBOS['id'].toString());
                                setState(() {
                                  _soalBOSList = _soalBOSApi.getAllSoalBOS();
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
