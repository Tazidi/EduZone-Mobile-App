import 'package:admin_152022047/api/local_api.dart';
import 'package:flutter/material.dart';
import 'package:admin_152022047/styles.dart'; // Import AppColors dari styles.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDashboard extends StatelessWidget {
  Future<void> _fetchTables(BuildContext context) async {
    try {
      final response =
          await http.get(Uri.parse('${LocalApi.baseUrl}/all-tables'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('No Tables Found'),
              content: Text('Database does not contain any tables.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowAllTablesPage(tableData: data),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Failed to fetch data. Status code: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: AppColors.royalBlue, // RoyalBlue dari styles.dart
      ),
      body: Container(
        color: AppColors.skyBlue, // SkyBlue dari styles.dart
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.powderBlue, // PowderBlue dari styles.dart
            ),
            onPressed: () => _fetchTables(context),
            child: Text('View All Tables'),
          ),
        ),
      ),
    );
  }
}

class ShowAllTablesPage extends StatelessWidget {
  final Map<String, dynamic> tableData;

  ShowAllTablesPage({required this.tableData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Semua Table',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue, // SkyBlue dari styles.dart
        child: ListView.builder(
          itemCount: tableData.keys.length,
          itemBuilder: (context, index) {
            final tableName = tableData.keys.elementAt(index);
            final tableContent = tableData[tableName] as List<dynamic>;
            return Card(
              color: AppColors.powderBlue, // PowderBlue dari styles.dart
              child: ListTile(
                leading: Icon(Icons.table_chart, color: AppColors.lightAshGray),
                title: Text(
                  tableName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TableDetailPage(
                        tableName: tableName,
                        tableContent: tableContent,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class TableDetailPage extends StatelessWidget {
  final String tableName;
  final List<dynamic> tableContent;

  TableDetailPage({required this.tableName, required this.tableContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tableName,
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue, // SkyBlue dari styles.dart
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Gulir horizontal untuk tabel
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Gulir vertikal untuk isi tabel
            child: DataTable(
              columns: _generateColumns(),
              rows: _generateRows(),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _generateColumns() {
    if (tableContent.isEmpty || tableContent.first is! Map<String, dynamic>)
      return [];
    final columns = (tableContent.first as Map<String, dynamic>).keys;
    return columns
        .map((col) => DataColumn(
            label: Text(col, style: TextStyle(fontWeight: FontWeight.bold))))
        .toList();
  }

  List<DataRow> _generateRows() {
    if (tableContent.isEmpty || tableContent.first is! Map<String, dynamic>)
      return [];
    return tableContent.map((row) {
      final cells = (row as Map<String, dynamic>).values;
      return DataRow(
        cells: cells.map((cell) => DataCell(Text(cell.toString()))).toList(),
      );
    }).toList();
  }
}
