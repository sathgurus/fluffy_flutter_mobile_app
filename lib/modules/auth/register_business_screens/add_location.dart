import 'package:fluffy/modules/auth/register_business_screens/application_sumbit.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/location_model.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/location_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final TextEditingController addressController = TextEditingController();

  LatLng? _selectedLocation;
  MapController mapController = MapController();

  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString("userId");
    });

    print("User ID: $userId");
  }

  Future<void> _loadUserLocation() async {
    final authProvider = Provider.of<LoginProvider>(context, listen: false);
    await authProvider.loadUserData();
  }

  // -------------------- Get Current GPS Location --------------------
  Future<void> useCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location service")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });

      mapController.move(_selectedLocation!, 15);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get GPS location'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // -------------------- Submit Location --------------------
  Future<void> submitLocation() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location on map!")),
      );
      return;
    }

    try {
      final provider = Provider.of<LocationProvider>(context, listen: false);

      final result = await provider.updateLocation(
        LocationModel(
          businessOwnerId: userId!, // replace dynamic
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          address: addressController.text,
        ),
      );

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✔ Location Added Successfully"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ApplicationSubmittedScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location update failed. Try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: appBarWithBackButton(context, "Ping Location"),
      body: Column(
        children: [
          // -------------------- Address Field --------------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: addressController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                hintText: "Enter address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // -------------------- Map --------------------
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(20.5937, 78.9629), // India
                initialZoom: 4,
                onTap: (tapPos, latlng) {
                  setState(() => _selectedLocation = latlng);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: "com.fluffy.app",
                ),
                if (_selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // -------------------- Buttons --------------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Use Current Location
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: useCurrentLocation,
                    icon: const Icon(Icons.my_location, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    label: const Text(
                      "Use My Current Location",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Submit Location
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.loading ? null : submitLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child:
                        provider.loading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Submit Location",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
