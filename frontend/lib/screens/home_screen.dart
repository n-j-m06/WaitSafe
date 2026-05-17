import 'package:flutter/material.dart';
import 'trip_setup_screen.dart';
import 'ghost_mode_screen.dart';
import 'profile_screen.dart';
import 'emergency_contacts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1100;

            // MOBILE / TABLET
            if (!isDesktop) {
              return Center(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 750),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: _buildMainContent(context, isDark),
                  ),
                ),
              );
            }

            // DESKTOP
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT MAIN COMMAND CENTER
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: _buildMainContent(context, isDark),
                        ),
                      ),

                      // RIGHT SAFETY DASHBOARD
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const EmergencyContactsScreen(),
                                  ),
                                );
                              },
                              child: FeatureCard(
                                icon: Icons.groups,
                                title: "Emergency Contacts",
                                subtitle:
                                    "Manage and instantly access your trusted safety circle anytime.",
                                isDark: isDark,
                                largeDesktop: true,
                              ),
                            ),

                            const SizedBox(height: 22),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ProfileScreen(),
                                  ),
                                );
                              },
                              child: FeatureCard(
                                icon: Icons.shield,
                                title: "Real-time Protection",
                                subtitle:
                                    "24/7 intelligent protection with proactive safety readiness.",
                                isDark: isDark,
                                largeDesktop: true,
                              ),
                            ),

                            const SizedBox(height: 22),

                            FeatureCard(
                              icon: Icons.notifications_active,
                              title: "Instant Alerts",
                              subtitle:
                                  "Timer SOS, Panic SOS, and immediate response when every second matters.",
                              isDark: isDark,
                              largeDesktop: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isDark) {
    return Column(
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
                    color: const Color(
                      0xFFFF4FA3,
                    ).withOpacity(isDark ? 0.6 : 0.3),
                    blurRadius: isDark ? 25 : 14,
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
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [Colors.white, const Color(0xFFFF4FA3)]
                    : [const Color(0xFFB0005A), const Color(0xFFFF4FA3)],
              ).createShader(bounds),
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  "WaitSafe",
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Georgia',
                    color: Colors.white,
                    letterSpacing: 1.8,
                    shadows: [
                      Shadow(
                        color: isDark
                            ? const Color(0xFFFF4FA3)
                            : const Color(0x55FF4FA3),
                        blurRadius: isDark ? 18 : 8,
                      ),
                    ],
                  ),
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
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                isDark ? const Color(0xFFFF4FA3) : const Color(0xFFCC3D84),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4FA3).withOpacity(isDark ? 0.5 : 0.2),
                blurRadius: isDark ? 12 : 6,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        Text(
          "STAY SAFE, STAY CONNECTED",
          style: TextStyle(
            color: isDark ? const Color(0xFFFF6FB8) : const Color(0xFFCC3D84),
            letterSpacing: 4,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 28),

        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20,
              color: isDark ? Colors.white : const Color(0xFF05060A),
            ),
            children: const [
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

        // MAIN COMMAND CARD
        Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B0D14) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0x22FF4FA3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.5 : 0.12),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInputField(
                context: context,
                hint: "Enter Destination",
                icon: Icons.location_on,
              ),

              const SizedBox(height: 18),

              _buildInputField(
                context: context,
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
                      color: const Color(0xFFFF4FA3).withOpacity(0.45),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.shield, color: Colors.white, size: 28),
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
                      Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // GHOST MODE
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GhostModeScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF4FA3), width: 1.4),
                  minimumSize: const Size(double.infinity, 84),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.grid_view_rounded, color: Color(0xFFFF6FB8)),
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
                    Icon(Icons.arrow_forward_ios, color: Color(0xFFFF6FB8)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildInputField({
    required BuildContext context,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF05060A),
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF9B9BA5) : Colors.black45,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x33FF4FA3),
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.white : const Color(0xFF05060A),
          ),
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: isDark ? const Color(0xFF090B12) : Colors.white,
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
  final bool isDark;
  final bool largeDesktop;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.largeDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(largeDesktop ? 28 : 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: largeDesktop ? 34 : 24,
            backgroundColor: const Color(0x22FF4FA3),
            child: Icon(
              icon,
              color: const Color(0xFFFF6FB8),
              size: largeDesktop ? 34 : 24,
            ),
          ),

          SizedBox(height: largeDesktop ? 18 : 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF05060A),
              fontWeight: FontWeight.bold,
              fontSize: largeDesktop ? 24 : 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? const Color(0xFF9B9BA5) : Colors.black54,
              fontSize: largeDesktop ? 15 : 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
