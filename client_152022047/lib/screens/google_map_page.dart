import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:client_152022047/geocoding.dart';
import 'package:client_152022047/styles.dart';
import 'dart:math';

class GoogleMapPage extends StatefulWidget {
  GoogleMapPage();

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _userMarkerPosition;
  LatLng? _schoolMarkerPosition;
  double _distance = 0.0;

  final LatLng _initialPosition = const LatLng(-6.914744, 107.609810);
  TextEditingController _searchController = TextEditingController();
  final GeocodingService _geocodingService = GeocodingService();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _searchSchool() async {
    String schoolName = _searchController.text.trim();
    if (schoolName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama sekolah tidak boleh kosong!')),
      );
      return;
    }

    try {
      var data = await _geocodingService.searchSchoolByName(schoolName);
      if (data['dataSekolah'] != null && data['dataSekolah'].isNotEmpty) {
        var schoolData = data['dataSekolah'][0];
        double? latitude = double.tryParse(schoolData['lintang']);
        double? longitude = double.tryParse(schoolData['bujur']);

        if (latitude != null && longitude != null) {
          LatLng targetPosition = LatLng(latitude, longitude);
          setState(() {
            _schoolMarkerPosition = targetPosition;
            _markers.add(
              Marker(
                markerId: MarkerId(schoolData['id']),
                position: targetPosition,
                infoWindow: InfoWindow(
                  title: schoolData['sekolah'],
                  snippet: schoolData['alamat_jalan'],
                ),
              ),
            );
          });
          mapController
              .animateCamera(CameraUpdate.newLatLngZoom(targetPosition, 15));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Lokasi ditemukan: ${schoolData['sekolah']} (${schoolData['alamat_jalan']})'),
            ),
          );
        } else {
          throw Exception('Koordinat tidak tersedia untuk sekolah ini.');
        }
      } else {
        throw Exception('Sekolah tidak ditemukan');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double radius = 6371;
    double lat1 = start.latitude;
    double lon1 = start.longitude;
    double lat2 = end.latitude;
    double lon2 = end.longitude;

    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  void _onTap(LatLng position) {
    setState(() {
      _userMarkerPosition = position;
      _markers.add(
        Marker(
          markerId: MarkerId('userMarker'),
          position: position,
          infoWindow: InfoWindow(
            title: 'Marker Pengguna',
            snippet: 'Ini adalah marker posisi pengguna',
          ),
        ),
      );
    });
  }

  void _calculateAndDrawLine() {
    if (_userMarkerPosition != null && _schoolMarkerPosition != null) {
      setState(() {
        _distance =
            _calculateDistance(_userMarkerPosition!, _schoolMarkerPosition!);

        _polylines.add(
          Polyline(
            polylineId: PolylineId('line'),
            points: [_userMarkerPosition!, _schoolMarkerPosition!],
            color: AppColors.royalBlue,
            width: 5,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pastikan kedua marker sudah ditempatkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        backgroundColor: AppColors.royalBlue,
        titleTextStyle: TextStyle(
          color: AppColors.softBeige, // Mengubah warna teks menjadi softBeige
          fontSize: 20, // Ukuran font
          fontWeight: FontWeight.bold, // Membuat teks bold
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama sekolah...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: AppColors.royalBlue),
                  onPressed: _searchSchool,
                ),
                filled: true,
                fillColor: AppColors.powderBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 11.0,
              ),
              markers: _markers,
              polylines: _polylines,
              onTap: _onTap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _calculateAndDrawLine,
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.softBeige,
                backgroundColor: AppColors.royalBlue, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 24), // Ukuran button
              ),
              child: Text(
                'Hitung Jarak dan Gambar Garis',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_distance > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.powderBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Jarak antara marker: ${_distance.toStringAsFixed(2)} km (${(_distance * 1000).toStringAsFixed(0)} meter)',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.royalBlue,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
