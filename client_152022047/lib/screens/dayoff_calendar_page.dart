import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:client_152022047/styles.dart';

class DayOffCalendarPage extends StatefulWidget {
  @override
  _DayOffCalendarPageState createState() => _DayOffCalendarPageState();
}

class _DayOffCalendarPageState extends State<DayOffCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _holidayEvents = {};

  @override
  void initState() {
    super.initState();
    _fetchHolidays();
  }

  Future<void> _fetchHolidays() async {
    const apiUrl = 'https://dayoffapi.vercel.app/api';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _holidayEvents = {
            for (var event in data)
              _normalizeDate(event['tanggal']): [event['keterangan']],
          };
        });
      } else {
        throw Exception('Failed to load holidays');
      }
    } catch (e) {
      print('Error fetching holidays: $e');
    }
  }

  DateTime _normalizeDate(String rawDate) {
    try {
      // Pisahkan tanggal berdasarkan tanda '-'
      final parts = rawDate.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1].padLeft(2, '0'); // Pastikan dua digit
        final day = parts[2].padLeft(2, '0'); // Pastikan dua digit
        return DateTime.parse('$year-$month-$day');
      } else {
        throw FormatException('Invalid date format: $rawDate');
      }
    } catch (e) {
      print('Error normalizing date: $e');
      throw FormatException('Invalid date format: $rawDate');
    }
  }

  String formatTanggal(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  List<String> _getEventsForDay(DateTime day) {
    return _holidayEvents[day] ?? [];
  }

  List<DateTime> _getEventsForMonth(DateTime month) {
    return _holidayEvents.keys.where((date) {
      return date.year == month.year && date.month == month.month;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventsForMonth = _getEventsForMonth(_focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalender Libur',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppColors.royalBlue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.powderBlue,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: Colors.black87),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                decoration: BoxDecoration(
                  color: AppColors.powderBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                titleTextStyle: TextStyle(
                  color: AppColors.royalBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (day.weekday == DateTime.sunday) {
                    // Hanya hari Minggu diberi warna merah
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: Colors.red, // Warna untuk hari Minggu
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                          color: Colors
                              .black87), // Warna default untuk hari lainnya
                    ),
                  );
                },
                markerBuilder: (context, day, events) {
                  if (_holidayEvents.containsKey(day)) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              eventLoader: _getEventsForDay,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  if (_selectedDay != null &&
                      _getEventsForDay(_selectedDay!).isNotEmpty) ...[
                    Card(
                      color: AppColors.powderBlue,
                      child: ListTile(
                        title: Text(
                          formatTanggal(_selectedDay!),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.royalBlue,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _getEventsForDay(_selectedDay!)
                              .map((event) => Text(event))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                  const Divider(),
                  ...eventsForMonth.map((date) {
                    final eventDetails = _getEventsForDay(date);
                    return Card(
                      color: AppColors.powderBlue,
                      child: ListTile(
                        title: Text(
                          formatTanggal(date),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.royalBlue,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              eventDetails.map((event) => Text(event)).toList(),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
