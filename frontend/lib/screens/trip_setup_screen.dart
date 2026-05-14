import 'package:flutter/material.dart';
import 'active_trip_screen.dart';

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

  void startJourney() {
    final destination = destinationController.text.trim();
    final timerText = timerController.text.trim();
    final contact = contactController.text.trim();

    if (destination.isEmpty || timerText.isEmpty || contact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please complete all trip details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFFFF4FA3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
      return;
    }

    final int? minutes = int.tryParse(timerText);

    if (minutes == null || minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Enter valid travel time in minutes",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveTripScreen(
          destination: destination,
          durationMinutes: minutes,
          emergencyContact: contact,
          liveTracking: liveTracking,
        ),
      ),
    );
  }

  @override
  void dispose() {
    destinationController.dispose();
    timerController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 950;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF05060A),
        ),
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
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT PANEL
                          Expanded(
                            flex: 3,
                            child: _buildJourneyForm(context, isDark),
                          ),

                          const SizedBox(width: 30),

                          // RIGHT PANEL
                          Expanded(flex: 2, child: _buildSafetyPanel(isDark)),
                        ],
                      )
                    : Column(
                        children: [
                          _buildJourneyForm(context, isDark),
                          const SizedBox(height: 24),
                          _buildSafetyPanel(isDark),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJourneyForm(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x22FF4FA3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.route, size: 90, color: Color(0xFFFF4FA3)),

          const SizedBox(height: 20),

          Text(
            "Prepare Your Safe Journey",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF05060A),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Set destination, timer, and emergency backup before you begin",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? const Color(0xFFB8B8C5) : Colors.black54,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 35),

          _buildField(
            context: context,
            controller: destinationController,
            hint: "Confirm Destination",
            icon: Icons.location_on,
          ),

          const SizedBox(height: 18),

          _buildField(
            context: context,
            controller: timerController,
            hint: "Estimated Travel Time (minutes)",
            icon: Icons.timer,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 18),

          _buildField(
            context: context,
            controller: contactController,
            hint: "Emergency Contact",
            icon: Icons.phone,
          ),

          const SizedBox(height: 28),

          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF11131A) : const Color(0xFFF8F9FD),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x22FF4FA3)),
            ),
            child: SwitchListTile(
              value: liveTracking,
              onChanged: (value) {
                setState(() {
                  liveTracking = value;
                });
              },
              activeColor: const Color(0xFFFF4FA3),
              title: Text(
                "Enable Live Tracking",
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF05060A),
                ),
              ),
              subtitle: Text(
                "Share your route with trusted contacts",
                style: TextStyle(
                  color: isDark ? const Color(0xFF9B9BA5) : Colors.black54,
                ),
              ),
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
            ),
            child: ElevatedButton(
              onPressed: startJourney,
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
        ],
      ),
    );
  }

  Widget _buildSafetyPanel(bool isDark) {
    return Column(
      children: [
        _featureCard(
          icon: Icons.shield,
          title: "Auto SOS Protection",
          subtitle:
              "If your timer expires, emergency alerts automatically trigger.",
          isDark: isDark,
        ),
        const SizedBox(height: 18),
        _featureCard(
          icon: Icons.people,
          title: "Trusted Circle",
          subtitle: "Your saved emergency contacts are instantly notified.",
          isDark: isDark,
        ),
        const SizedBox(height: 18),
        _featureCard(
          icon: Icons.location_history,
          title: "Live Tracking",
          subtitle:
              "Optional route visibility for added safety and accountability.",
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0x22FF4FA3),
            child: Icon(icon, color: const Color(0xFFFF6FB8), size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF05060A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? const Color(0xFFB8B8C5) : Colors.black54,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF05060A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF9B9BA5) : Colors.black45,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFFF6FB8)),
        filled: true,
        fillColor: isDark ? const Color(0xFF11131A) : const Color(0xFFF8F9FD),
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
