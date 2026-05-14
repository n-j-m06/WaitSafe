import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'safe_zone_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: const Color(0xFF05060A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF05060A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Color(0xFFFF6FB8),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildMainProfilePanel(context),
                        ),
                        const SizedBox(width: 28),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: const [
                              _DesktopInfoCard(
                                icon: Icons.shield,
                                title: "Protection Status",
                                subtitle:
                                    "Your WaitSafe ecosystem is fully active and guarding every journey.",
                              ),
                              SizedBox(height: 22),
                              _DesktopInfoCard(
                                icon: Icons.visibility_off,
                                title: "Ghost Performance",
                                subtitle:
                                    "Stealth mode is optimized for discreet movement and secure silent backup.",
                              ),
                              SizedBox(height: 22),
                              _DesktopInfoCard(
                                icon: Icons.settings,
                                title: "System Controls",
                                subtitle:
                                    "Customize alerts, preferences, and advanced safety settings.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : _buildMainProfilePanel(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainProfilePanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          // PROFILE HEADER
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF05060A),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0x22FF4FA3)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x66FF4FA3), blurRadius: 18),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 52,
                    backgroundColor: Color(0xFF05060A),
                    child: Icon(Icons.person, size: 56, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Ami User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x22FF4FA3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "PROTECTED",
                    style: TextStyle(
                      color: Color(0xFFFF6FB8),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  "Your safety network is active and secured.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFB8B8C5), fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // STATS
          Row(
            children: const [
              Expanded(
                child: _StatCard(
                  icon: Icons.route,
                  count: "24",
                  label: "Saved Trips",
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  icon: Icons.groups,
                  count: "5",
                  label: "Trusted Contacts",
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  icon: Icons.visibility_off,
                  count: "12",
                  label: "Ghost Uses",
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // EDIT PROFILE
          _buildActionButton(
            context: context,
            icon: Icons.edit,
            title: "Edit Profile",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Edit Profile Coming Soon",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: const Color(0xFFFF4FA3),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(20),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // APP SETTINGS
          _buildActionButton(
            context: context,
            icon: Icons.settings,
            title: "App Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),

          const SizedBox(height: 16),

          // SAFE ZONE SETUP
          _buildActionButton(
            context: context,
            icon: Icons.location_city,
            title: "Safe Zone Setup",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SafeZoneScreen()),
              );
            },
          ),

          const SizedBox(height: 16),

          // LOGOUT
          _buildActionButton(
            context: context,
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x44FF4FA3)),
        color: const Color(0xFF05060A),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFFFF6FB8)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFFF6FB8),
          size: 18,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;

  const _StatCard({
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF05060A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF6FB8), size: 30),

          const SizedBox(height: 12),

          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFB8B8C5), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _DesktopInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DesktopInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 28),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: const Color(0x22FF4FA3),
            child: Icon(icon, color: const Color(0xFFFF6FB8), size: 34),
          ),

          const SizedBox(height: 22),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFFB8B8C5),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
