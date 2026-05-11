// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'trip_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 750),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // LOGO + TITLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF4FA3).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 3,
                            ),
                          ],
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                          ),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      const SizedBox(width: 18),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFFF4FA3)],
                        ).createShader(bounds),
                        child: const Text(
                          "WaitSafe",
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Georgia',
                            color: Colors.white,
                            letterSpacing: 1.8,
                            shadows: [
                              Shadow(color: Color(0xFFFF4FA3), blurRadius: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    height: 2,
                    width: 320,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFFFF4FA3),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4FA3).withOpacity(0.5),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "STAY SAFE, STAY CONNECTED",
                    style: TextStyle(
                      color: Color(0xFFFF6FB8),
                      letterSpacing: 4,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 28),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      children: [
                        TextSpan(text: "Your trusted "),
                        TextSpan(
                          text: "late-night",
                          style: TextStyle(
                            color: Color(0xFFFF4FA3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " safety companion"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 34),

                  // MAIN CARD
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B0D14),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0x22FF4FA3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // DESTINATION
                        _buildInputField(
                          hint: "Enter Destination",
                          icon: Icons.location_on,
                        ),

                        const SizedBox(height: 18),

                        // TIMER
                        _buildInputField(
                          hint: "Set Timer (minutes)",
                          icon: Icons.access_time_filled,
                          suffix: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x33FF4FA3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              "min",
                              style: TextStyle(
                                color: Color(0xFFFF6FB8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // START SAFE WALK
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF4FA3,
                                ).withOpacity(0.45),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TripSetupScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 26),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(
                                  Icons.shield,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                Text(
                                  "START SAFE WALK",
                                  style: TextStyle(
                                    fontSize: 26,
                                    letterSpacing: 3.2,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // GHOST MODE
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFFF4FA3),
                              width: 1.4,
                            ),
                            minimumSize: const Size(double.infinity, 84),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(
                                Icons.grid_view_rounded,
                                color: Color(0xFFFF6FB8),
                              ),
                              Text(
                                "GHOST MODE",
                                style: TextStyle(
                                  fontSize: 24,
                                  letterSpacing: 4,
                                  color: Color(0xFFFFB6D9),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFFFF6FB8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // FEATURE BOXES
                  Row(
                    children: const [
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.groups,
                          title: "Emergency Contacts",
                          subtitle: "Quick access to your saved contacts",
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.shield,
                          title: "Real-time Protection",
                          subtitle: "We've got your back 24/7",
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.notifications_none,
                          title: "Instant Alerts",
                          subtitle: "Instantly notify when you need help",
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

  static Widget _buildInputField({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9B9BA5)),
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0x33FF4FA3),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF090B12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0x44FF4FA3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFFF4FA3)),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0x22FF4FA3),
            child: Icon(icon, color: const Color(0xFFFF6FB8)),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
