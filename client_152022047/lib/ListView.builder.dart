import 'package:flutter/material.dart';
import 'package:client_152022047/api/api_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  void _searchSchool() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await apiService.searchSchool(_searchController.text);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search School'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'School Name',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchSchool,
                ),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: _searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final school = _searchResults[index];
                              return ListTile(
                                title: Text(school['sekolah'] ?? 'Unknown'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        school['alamat_jalan'] ?? 'No Address'),
                                    Text(
                                        'Bentuk: ${school['bentuk'] ?? 'N/A'}'),
                                    Text(
                                        'Kecamatan: ${school['kecamatan'] ?? 'N/A'}'),
                                    Text(
                                        'Propinsi: ${school['propinsi'] ?? 'N/A'}'),
                                  ],
                                ),
                                trailing: Icon(Icons.location_on),
                                onTap: () {
                                  // Aksi lain ketika item ditekan, misal menampilkan detail atau navigasi
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text('No results found.'),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
