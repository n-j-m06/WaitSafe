import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static const String baseUrl = "http://127.0.0.1:8000";

  // UPDATE LIVE LOCATION
  static Future<Map<String, dynamic>> updateLocation(
    String token,
    double latitude,
    double longitude,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/location/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"latitude": latitude, "longitude": longitude}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update location: ${response.body}");
    }
  }

  // CREATE SAFE ZONE
  static Future<Map<String, dynamic>> createSafeZone(
    String token,
    String name,
    double latitude,
    double longitude,
    int radiusMeters,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/location/safe-zone'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "radius_meters": radiusMeters,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create safe zone: ${response.body}");
    }
  }

  // GET SAFE ZONES
  static Future<List<dynamic>> getSafeZones(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/location/safe-zones'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch safe zones: ${response.body}");
    }
  }

  // GET CURRENT DEVICE LOCATION
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // START LIVE TRACKING
  static StreamSubscription<Position> startLiveTracking(
    String token,
    Function(Position) onLocationUpdate,
  ) {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      try {
        await updateLocation(token, position.latitude, position.longitude);

        onLocationUpdate(position);
      } catch (e) {
        print("Live tracking error: $e");
      }
    });
  }
}
