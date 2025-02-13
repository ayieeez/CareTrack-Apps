import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'landing_page.dart';
import 'about_page.dart';
import 'profile_page.dart';

void main() {
  runApp(NearbyClinicPage());
}

class NearbyClinicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _userLocation = LatLng(2.1896, 102.2501); // Default location
  int _currentIndex = 1;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Fetch user location when app starts
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _addNearbyHospitals();
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(_userLocation));
  }

  void _addNearbyHospitals() {
    List<LatLng> hospitalLocations = [
      LatLng(2.304673, 102.429808),
      LatLng(2.2183863, 102.2617829),
      LatLng(2.2375582, 102.2869622),
      LatLng(2.2776287646961197, 102.3908788153456),
      LatLng(2.3068226433828163, 102.4299677442291),
      LatLng(2.1536836254842107, 102.42766716448534),
      LatLng(2.187479549444699, 102.25148738814158),
      LatLng(2.313117077264508, 102.4326751884025),
      LatLng(2.29863230646858, 102.4181569668792),
      LatLng(2.3128047685831126, 102.43174834401943),
      LatLng(2.1646519727708933, 102.42979131156103),
      LatLng(2.3122179824468705, 102.43209711484062),
      LatLng(2.1678165716505786, 102.43126197763169),
      LatLng(2.2303360394789657, 102.27257001158686),
    ];

    List<String> hospitalNames = [
      "Hospital Jasin",
      "Melaka General Hospital",
      "Pantai Hospital Ayer Keroh",
      "Klinik Hayat Jasin",
      "Klinik Kesihatan Jasin",
      "Klinik Kesihatan Merlimau",
      "Mahkota Medical Centre",
      "Klinik Keluarga One Medic",
      "Klinik Dr Zanawati",
      "Klinik Mawar dan Pembedahan Jasin",
      "Klinik Annas Merlimau",
      "Poliklinik Hidayah",
      "Uni Klinik Merlimau",
      "Klinik ECTO 24 Jam",
    ];

    for (int i = 0; i < hospitalLocations.length; i++) {
      LatLng location = hospitalLocations[i];
      _markers.add(
        Marker(
          markerId: MarkerId("hospital_$i"),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title:
                "${hospitalNames[i]} \nLatitude : ${location.latitude} \nLongitude : ${location.longitude}",
          ),
        ),
      );
    }

    setState(() {});
  }

  void _showHospitalDetails(String name, LatLng location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Latitude: ${location.latitude}"),
              Text("Longitude: ${location.longitude}"),
            ],
          ),
          actions: [
            TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close, color: Colors.red), // Close icon
                  SizedBox(width: 4), // Spacing
                  Text("Close"),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the respective page based on the index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()), // Home
        );
        break;
      case 1:
        // Already on the Nearby Clinics page, no action needed
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AboutPage()), // About
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()), // Profile
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 120,
          child: Image.asset(
            'assets/whitelogo.png',
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Full-screen Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: _userLocation,
              zoom: 14,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Nearby Clinics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}