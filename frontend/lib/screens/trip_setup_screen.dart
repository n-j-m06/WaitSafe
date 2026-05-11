import 'package:flutter/material.dart';

class TripSetupScreen extends StatefulWidget {
  const TripSetupScreen({super.key});

  @override
  State<TripSetupScreen> createState() => _TripSetupScreenState();
}

class _TripSetupScreenState extends State<TripSetupScreen> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController timerController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  bool liveTracking = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF05060A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Trip Setup",
          style: TextStyle(
            color: Color(0xFFFF6FB8),
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.route, size: 90, color: Color(0xFFFF4FA3)),

                  const SizedBox(height: 20),

                  const Text(
                    "Prepare Your Safe Journey",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Set destination, timer, and emergency backup before you begin",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFB8B8C5), fontSize: 17),
                  ),

                  const SizedBox(height: 35),

                  _buildField(
                    controller: destinationController,
                    hint: "Confirm Destination",
                    icon: Icons.location_on,
                  ),

                  const SizedBox(height: 18),

                  _buildField(
                    controller: timerController,
                    hint: "Estimated Travel Time",
                    icon: Icons.timer,
                  ),

                  const SizedBox(height: 18),

                  _buildField(
                    controller: contactController,
                    hint: "Emergency Contact",
                    icon: Icons.phone,
                  ),

                  const SizedBox(height: 28),

                  SwitchListTile(
                    value: liveTracking,
                    onChanged: (value) {
                      setState(() {
                        liveTracking = value;
                      });
                    },
                    activeColor: const Color(0xFFFF4FA3),
                    title: const Text(
                      "Enable Live Tracking",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: const Text(
                      "Share your live route with trusted contacts",
                      style: TextStyle(color: Color(0xFF9B9BA5)),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4FA3).withOpacity(0.4),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (destinationController.text.isEmpty ||
                            timerController.text.isEmpty ||
                            contactController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Please complete all trip details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: const Color(0xFFFF4FA3),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Journey Started Successfully",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "START JOURNEY",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: const [
                      Expanded(
                        child: _MiniFeature(
                          icon: Icons.shield,
                          title: "Auto SOS",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _MiniFeature(
                          icon: Icons.people,
                          title: "Trusted Circle",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _MiniFeature(
                          icon: Icons.notifications,
                          title: "Instant Alert",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9B9BA5)),
        prefixIcon: Icon(icon, color: const Color(0xFFFF6FB8)),
        filled: true,
        fillColor: const Color(0xFF0B0D14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0x33FF4FA3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFFF4FA3)),
        ),
      ),
    );
  }
}

class _MiniFeature extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MiniFeature({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF6FB8), size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
