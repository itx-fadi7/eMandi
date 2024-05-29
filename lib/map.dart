import 'package:emandi/model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geo;
// import 'package:geolocator/geolocator.dart' as geo;
import 'package:url_launcher/url_launcher.dart';

class City {
  final String name;
  final String province;
  final LatLng location;

  City(this.name, this.province, this.location);
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  List<Data> _photo = [];
  List<Data> filteredList = [];
  String targetLocation = '';
  List<Data> filterListByLocation(
      List<Data> originalList, String targetLocation) {
    return originalList
        .where((data) =>
            data.location.toLowerCase() == targetLocation.toLowerCase())
        .toList();
  }

  late GoogleMapController mapController;
  LatLng? _currentPosition;
  City? _selectedCity; // Define _selectedCity variable here
  final LatLng _initialPosition =
      LatLng(32.57666343384157, 74.09990181762352); // Gujrat Mandi coordinates
  final List<City> cities = [
    City('Sialkot Mandi', 'Punjab',
        LatLng(32.50008733699486, 74.52521916826785)),
    City(
        'Gujrat Mandi', 'Punjab', LatLng(32.57666343384157, 74.09990181762352)),
    City('Gujranwala Mandi', 'Punjab',
        LatLng(32.19338469101057, 74.18725930940599)),
    City('LalaMusa Mandi', 'Punjab',
        LatLng(32.70067680214251, 73.95578658124658)),
  ]; // Replace with desired city names, provinces, and coordinates

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // Function to calculate distance between two LatLng points
  double _calculateDistance(LatLng point1, LatLng point2) {
    final distance = Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
    return distance;
  }

  // Function to calculate estimated travel time
  double _calculateTravelTime(double distance) {
    const double averageSpeedKmPerHour = 50.0; // Average speed
    return distance / 1000 / averageSpeedKmPerHour; // time in hours
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location services and permissions
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Animate camera to current location and add markers
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition!, 15),
    );

    _addMarkers(); // Add markers for current location and all cities
    if (_selectedCity != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(_selectedCity!.location),
      );
    }
    // Calculate distances to all markers and find the nearest marker
    City? nearestCity;
    double minDistance = double.infinity;
    for (var city in cities) {
      double distance = _calculateDistance(_currentPosition!, city.location);
      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = city;
      }
    }

    if (nearestCity != null) {
      // Show dialog with marker details
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Nearest Mandi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${nearestCity?.name ?? 'Unknown'}'),
              Text('Province: ${nearestCity?.province ?? 'Unknown'}'),
              Text('Distance: ${(minDistance / 1000).toStringAsFixed(2)} km'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _drawPolylineToCity(nearestCity!); // Start navigation
              },
              child: Text('Start Directions'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Implement logic to select another marker
              },
              child: Text('Select Another Mandi'),
            ),
          ],
        ),
      );
    }
  }

  void _addMarkers() {
    final markers = <Marker>[
      Marker(
        markerId: MarkerId('currentLocation'),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: 'Current Location'),
      ),
      for (var city in cities)
        Marker(
          markerId: MarkerId(city.name),
          position: city.location,
          infoWindow: InfoWindow(title: city.name),
          onTap: () => _showBottomSheet(city),
        ),
    ];
    setState(() {
      _markers.addAll(markers);
    });
  }

  void _drawPolylineToCity(City city) {
    _polylines.clear();

    final polylineCoordinates = [
      _currentPosition!,
      city.location,
    ];

    final polyline = Polyline(
      polylineId: PolylineId(city.name),
      color: Colors.red, // Customize color as desired
      width: 5,
      points: polylineCoordinates,
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

  void _showBottomSheet(City city) {
    final distance = _calculateDistance(_currentPosition!, city.location);
    final travelTime = _calculateTravelTime(distance);
    setState(() {
      _selectedCity = city; // Assign selected city to _selectedCity variable
    });

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('City: ${city.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Province: ${city.province}'),
            Text('Distance: ${(distance / 1000).toStringAsFixed(2)} km'),
            Text('Estimated Time: ${travelTime.toStringAsFixed(2)} hours'),
            SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _drawPolylineToCity(city);
                      },
                      child: Text('Direction'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Implement start navigation logic here
                        _startNavigation(city);
                      },
                      child: Text('Start'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (city.name == 'Gujrat') {
                      setState(() {
                        targetLocation = 'Gujrat';
                        filteredList =
                            filterListByLocation(_photo, targetLocation!);
                        print('Filtering for Gujrat');
                      });
                      Navigator.pop(context);
                    } else if (city.name == 'Gujranwala') {
                      setState(() {
                        targetLocation = 'Gujranwala';
                        filteredList =
                            filterListByLocation(_photo, targetLocation!);
                        print('Filtering for GRW');
                      });
                      Navigator.pop(context);
                    } else if (city.name == 'Sialkot') {
                      setState(() {
                        targetLocation = 'Sialkot';
                        filteredList =
                            filterListByLocation(_photo, targetLocation!);
                        print('Filtering for SIA');
                      });
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        targetLocation = 'Lalamusa';
                        filteredList =
                            filterListByLocation(_photo, 'Lalamusa'!);
                        print('Filtering for Lala');
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('View ${city.name} Listing'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startNavigation(City city) async {
    // Example using url_launcher to open a web page for navigation
    String origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    String destination = '${city.location.latitude},${city.location.longitude}';
    String url =
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch navigation');
    }
  }

  void _updateCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers
          .removeWhere((marker) => marker.markerId.value == 'currentLocation');
      _markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: 'Current Location'),
      ));
    });

    mapController.animateCamera(
      CameraUpdate.newLatLng(_currentPosition!),
    );
  }

  Future<void> _searchPlace(String query) async {
    List<geo.Location> locations = await geo.locationFromAddress(query);

    if (locations.isNotEmpty) {
      geo.Location location = locations.first;
      LatLng searchedLocation = LatLng(location.latitude, location.longitude);

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(searchedLocation, 15),
      );
    } else {
      Fluttertoast.showToast(msg: 'Place not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Example'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search place...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          _searchPlace(value);
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Implement search functionality
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              child: Icon(Icons.near_me),
              onPressed: _getCurrentLocation,
            ),
          ),
        ],
      ),
    );
  }
}
