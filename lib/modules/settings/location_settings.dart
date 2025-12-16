import 'package:fluffy/modules/auth/register_business_screens/model/location_model.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/location_provider.dart';
import 'package:fluffy/modules/settings/provider/profileProvider.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:fluffy/modules/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSettings extends StatefulWidget {
  const LocationSettings({super.key});

  @override
  State<LocationSettings> createState() => _LocationSettingsState();
}

class _LocationSettingsState extends State<LocationSettings> {
  LatLng? _selectedLocation;
  MapController mapController = MapController();
  String? userId;

  @override
  void initState() {
    super.initState();
    loadUserAndFetch();
  }

  Future<void> loadUserAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("userId");

    if (id != null) {
      userId = id;

      context.read<Profileprovider>().fetchBusinessDetails(id);
    }
  }

  void _shareLocation(Map<String, dynamic> data) {
    final address = data['address'];

    if (address == null || address.toString().isEmpty) return;

    final coords = data['location']?['coordinates'];

    String mapsLink = "";
    if (coords is List && coords.length == 2) {
      final lng = coords[0];
      final lat = coords[1];
      mapsLink = "https://www.google.com/maps?q=$lat,$lng";
    }

    final message = '''📍 Current Business Location $address $mapsLink ''';

    Share.share(message.trim());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<Profileprovider>();
    final data = provider.locationData;

    // If API has coordinates and _selectedLocation not set yet
    if (_selectedLocation == null && data.isNotEmpty) {
      final coords = data['location']?['coordinates'];
      if (coords is List && coords.length == 2) {
        // API gives [lng, lat]
        _selectedLocation = LatLng(coords[1], coords[0]);
      }
    }
  }

  Future<void> useCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ToastificationShow.showToast(
          context: context,
          title: "Add Location",
          description: "Please enable location service",
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
      ToastificationShow.showToast(
        context: context,
        title: "Add Location",
        description: "Failed to get GPS location",
      );
    }
  }

  // -------------------- Submit Location --------------------
  Future<void> submitLocation() async {
    if (_selectedLocation == null) {
      ToastificationShow.showToast(
        context: context,
        title: "Add Location",
        description: "Please select a location on map!",
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
        ),
      );

      if (result) {
        ToastificationShow.showToast(
          context: context,
          title: "Add Location",
          description: "Location updated Successfully.",
        );
        context.read<Profileprovider>().fetchBusinessDetails(userId!);
      }
    } catch (e) {
      ToastificationShow.showToast(
        context: context,
        title: "Add Loactions",
        description: "Location update failed. Try again.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Profileprovider>();
    final locationProvider = Provider.of<LocationProvider>(context);
    final data = provider.locationData;
    print("sho details $data");
    return Scaffold(
      appBar: appBarWithBackButton(context, "Location Settings"),
      body: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            data.isEmpty
                ? const Center(child: Text("Location not added"))
                : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    color: AppColors.whiteColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Header Row
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 6),

                              TextWidget(
                                text: "Current Location",
                                fontWeight: FontWeight.w600,
                              ),

                              const Spacer(), // 👈 Push menu to right

                              PopupMenuButton<String>(
                                color: AppColors.whiteColor,
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'share') {
                                    _shareLocation(data);
                                  }
                                },
                                itemBuilder:
                                    (context) => [
                                      const PopupMenuItem(
                                        value: 'share',
                                        child: Row(
                                          children: [
                                            Icon(Icons.share, size: 18),
                                            SizedBox(width: 8),
                                            Text("Share"),
                                          ],
                                        ),
                                      ),
                                    ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          // 🔹 Address Text
                          TextWidget(
                            text: data['address'] ?? "Address not available",
                            maxLines: 5,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            Expanded(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center:
                      _selectedLocation ?? LatLng(20.5937, 78.9629), // fallback
                  zoom: _selectedLocation != null ? 15 : 4,
                  onTap: (tapPos, latlng) {
                    setState(() => _selectedLocation = latlng);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                      onPressed:
                          locationProvider.loading ? null : submitLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child:
                          locationProvider.loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Update Location",
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
      ),
    );
  }
}
