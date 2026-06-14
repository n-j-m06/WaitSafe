import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class SafeZoneScreen extends StatefulWidget {
  const SafeZoneScreen({super.key});

  @override
  State<SafeZoneScreen> createState() => _SafeZoneScreenState();
}

class _SafeZoneScreenState extends State<SafeZoneScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  bool isLoading = false;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  void showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showSnack("Location services are disabled", Colors.redAccent);
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      showSnack("Location permissions permanently denied", Colors.redAccent);
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();

    showSnack("Current location loaded", Colors.green);
  }

  Future<void> saveSafeZone() async {
    print("SAVE BUTTON CLICKED");

    if (nameController.text.isEmpty ||
        latitudeController.text.isEmpty ||
        longitudeController.text.isEmpty ||
        radiusController.text.isEmpty) {
      showSnack("Fill all fields", Colors.redAccent);
      return;
    }

    setState(() => isLoading = true);

    try {
      final token = await getToken();

      print("TOKEN: $token");

      if (token == null) {
        showSnack("Login expired", Colors.redAccent);
        return;
      }

      print("Sending Safe Zone:");
      print("Name: ${nameController.text.trim()}");
      print("Lat: ${latitudeController.text.trim()}");
      print("Lng: ${longitudeController.text.trim()}");
      print("Radius: ${radiusController.text.trim()}");

      final response = await LocationService.createSafeZone(
        token,
        nameController.text.trim(),
        double.parse(latitudeController.text.trim()),
        double.parse(longitudeController.text.trim()),
        int.parse(radiusController.text.trim()),
      );

      print("API RESPONSE: $response");

      showSnack("Safe Zone Created: ${response["name"]}", Colors.green);

      nameController.clear();
      latitudeController.clear();
      longitudeController.clear();
      radiusController.clear();
    } catch (e) {
      print("SAFE ZONE ERROR: $e");
      showSnack("Error: $e", Colors.redAccent);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildField(
    String hint,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType:
            hint.contains("Latitude") ||
                hint.contains("Longitude") ||
                hint.contains("Radius")
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: const Color(0xFFFF4FA3)),
          filled: true,
          fillColor: const Color(0xFF0B0D14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0x44FF4FA3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFFF4FA3)),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF05060A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Safe Zone Setup",
          style: TextStyle(
            color: Color(0xFFFF6FB8),
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 650),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.location_city,
                  size: 90,
                  color: Color(0xFFFF4FA3),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Create Your Safety Boundary",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                const Text(
                  "Define a zone where you should remain safe.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                buildField(
                  "Safe Zone Name",
                  nameController,
                  Icons.edit_location_alt,
                ),

                buildField("Latitude", latitudeController, Icons.my_location),

                buildField("Longitude", longitudeController, Icons.map),

                buildField(
                  "Radius (meters)",
                  radiusController,
                  Icons.radio_button_checked,
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: getCurrentLocation,
                    icon: const Icon(Icons.gps_fixed, color: Color(0xFFFF4FA3)),
                    label: const Text(
                      "USE CURRENT LOCATION",
                      style: TextStyle(
                        color: Color(0xFFFF6FB8),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(color: Color(0xFFFF4FA3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveSafeZone,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: const Color(0xFFFF4FA3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SAVE SAFE ZONE",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
