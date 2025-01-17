import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client_152022047/styles.dart';
import 'package:client_152022047/api/local_api.dart';

class NotesPage extends StatefulWidget {
  final int userId;

  NotesPage({required this.userId});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final String apiUrl = "${LocalApi.baseUrl}/api/notes";
  List<dynamic> _notes = [];
  final TextEditingController _tugasController = TextEditingController();
  final TextEditingController _kegiatanController = TextEditingController();
  DateTime? _selectedDeadline;
  int? _editingNoteId;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    try {
      final response =
          await http.get(Uri.parse("$apiUrl?user_id=${widget.userId}"));
      if (response.statusCode == 200) {
        setState(() {
          _notes = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to fetch notes');
      }
    } catch (e) {
      print("Error fetching notes: $e");
    }
  }

  Future<void> _deleteNote(int noteId) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$noteId"));
      if (response.statusCode == 200) {
        _fetchNotes();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Catatan berhasil dihapus')),
        );
      }
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  void _showEditForm(Map<String, dynamic>? note) {
    setState(() {
      if (note != null) {
        _editingNoteId = note['id'];
        _tugasController.text = note['tugas'] ?? '';
        _kegiatanController.text = note['kegiatan'] ?? '';
        _selectedDeadline = DateTime.parse(note['deadline']);
      } else {
        _editingNoteId = null;
        _tugasController.clear();
        _kegiatanController.clear();
        _selectedDeadline = null;
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.skyBlue, // Warna latar belakang dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Membuat sudut melengkung
          ),
          title: Text(
            _editingNoteId == null ? 'Tambah Catatan' : 'Edit Catatan',
            style: TextStyle(
              color: AppColors.royalBlue, // Warna teks judul royalBlue
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tugasController,
                  style: TextStyle(
                    fontSize: 14, // Ukuran font teks input
                    color: Colors.black, // Warna teks input (opsional)
                  ),
                  decoration: InputDecoration(
                    labelText: 'Tugas',
                    labelStyle: TextStyle(
                      fontSize: 20, // Ukuran font label
                      color: AppColors.royalBlue, // Warna label
                    ),
                    filled: true,
                    fillColor: AppColors.powderBlue, // Warna latar TextField
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _kegiatanController,
                  style: TextStyle(
                    fontSize: 14, // Ukuran font teks input
                    color: Colors.black, // Warna teks input (opsional)
                  ),
                  decoration: InputDecoration(
                    labelText: 'Kegiatan',
                    labelStyle: TextStyle(
                      fontSize: 20, // Ukuran font label
                      color: AppColors.royalBlue, // Warna label
                    ),
                    filled: true,
                    fillColor: AppColors.powderBlue, // Warna latar TextField
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDeadline == null
                            ? 'Pilih Deadline'
                            : 'Deadline: ${_selectedDeadline.toString().split(' ')[0]}',
                        style: TextStyle(
                          color: AppColors.royalBlue, // Warna teks deadline
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _selectedDeadline = pickedDate;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            AppColors.royalBlue, // Warna latar tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Membuat sudut tombol melengkung
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6), // Ukuran tombol
                      ),
                      child: Text(
                        'Pilih Tanggal',
                        style: TextStyle(
                          color: AppColors.softBeige, // Warna teks softBeige
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _tugasController.clear();
                _kegiatanController.clear();
                _selectedDeadline = null;
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.red, // Warna tombol Batal
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Save or update note logic
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.softBeige,
                backgroundColor: AppColors.royalBlue, // Warna teks tombol
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Membulatkan sudut tombol
                ),
              ),
              child: Text(
                _editingNoteId == null ? 'Tambah' : 'Simpan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Catatan',
          style: TextStyle(
            color: AppColors.softBeige, // Warna teks softBeige
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.royalBlue, // Latar belakang royalBlue
        iconTheme:
            IconThemeData(color: AppColors.softBeige), // Warna ikon softBeige
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchNotes, // Fungsi untuk merefresh catatan
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                _showEditForm(null), // Fungsi untuk menambah catatan
          ),
        ],
      ),
      body: Container(
        color: AppColors.skyBlue,
        padding: EdgeInsets.all(8),
        child: _notes.isEmpty
            ? Center(
                child: Text(
                  'Tidak ada catatan',
                  style: TextStyle(fontSize: 18, color: AppColors.royalBlue),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.powderBlue,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              note['tugas'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.royalBlue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _deleteNote(note['id']);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          note['kegiatan'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Deadline: ${DateTime.parse(note['deadline']).toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppColors.royalBlue,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () => _showEditForm(note),
                          icon: Icon(Icons.edit, size: 16),
                          label: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.royalBlue,
                            minimumSize: Size(double.infinity, 36),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
