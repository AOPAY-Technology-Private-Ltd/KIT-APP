import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomerLocationScreen extends StatefulWidget {
  final Map<String, dynamic> locationApiResponse;
  final String customerName;

  const CustomerLocationScreen({
    Key? key,
    required this.locationApiResponse,
    required this.customerName,
  }) : super(key: key);

  @override
  State<CustomerLocationScreen> createState() => _CustomerLocationScreenState();
}

class _CustomerLocationScreenState extends State<CustomerLocationScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  LatLng? _customerLatLng;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _parseLocationData();
  }

  void _parseLocationData() {
    try {
      final data = widget.locationApiResponse['data'];
      if (data != null && data is Map<String, dynamic>) {
        final double? lat = double.tryParse(data['latitude']?.toString() ?? '');
        final double? lng = double.tryParse(data['longitude']?.toString() ?? '');

        if (lat != null && lng != null) {
          _customerLatLng = LatLng(lat, lng);
          _markers.add(
            Marker(
              markerId: const MarkerId('customer_location'),
              position: _customerLatLng!,
              infoWindow: InfoWindow(
                title: widget.customerName,
                snippet: 'Lat: $lat, Lng: $lng',
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error parsing location: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.customerName} Location',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF3B82F6),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _customerLatLng == null
          ? const Center(
        child: Text(
          'Location data not available',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _customerLatLng!,
          zoom: 15.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}