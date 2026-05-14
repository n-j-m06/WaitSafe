import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool sosPermissions = true;
  bool liveTracking = true;
  bool emergencyAlerts = true;
  bool darkMode = true;
  bool ghostModeDefault = false;

  void showMessage(String message, Color color) {
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF05060A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0x22FF4FA3),
            child: Icon(icon, color: const Color(0xFFFF6FB8)),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9B9BA5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeColor: const Color(0xFFFF4FA3),
            onChanged: (value) => onChanged(value),
          ),
        ],
      ),
    );
  }

  Widget buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF05060A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF6FB8)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFFF6FB8),
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: const Color(0xFF05060A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF05060A),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "App Settings",
          style: TextStyle(
            color: Color(0xFFFF6FB8),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
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
                        Expanded(flex: 3, child: _buildMainPanel(context)),

                        const SizedBox(width: 28),

                        Expanded(
                          flex: 2,
                          child: Column(
                            children: const [
                              _DesktopInfoCard(
                                icon: Icons.security,
                                title: "Security Control",
                                subtitle:
                                    "Configure SOS, tracking, and emergency response systems.",
                              ),
                              SizedBox(height: 22),
                              _DesktopInfoCard(
                                icon: Icons.palette,
                                title: "Personalization",
                                subtitle:
                                    "Customize dark mode, ghost defaults, and user experience.",
                              ),
                              SizedBox(height: 22),
                              _DesktopInfoCard(
                                icon: Icons.admin_panel_settings,
                                title: "Account Protection",
                                subtitle:
                                    "Manage credentials, password security, and account controls.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : _buildMainPanel(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(Icons.settings, size: 95, color: Color(0xFFFF4FA3)),
          ),

          const SizedBox(height: 22),

          const Center(
            child: Text(
              "Control Your Safety Experience",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "Customize security, privacy, and account preferences",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: Color(0xFFB8B8C5)),
            ),
          ),

          const SizedBox(height: 35),

          const Text(
            "Security",
            style: TextStyle(
              color: Color(0xFFFF6FB8),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          buildToggleTile(
            icon: Icons.security,
            title: "SOS Permissions",
            subtitle: "Allow emergency SOS access",
            value: sosPermissions,
            onChanged: (value) {
              setState(() => sosPermissions = value);
            },
          ),

          buildToggleTile(
            icon: Icons.location_on,
            title: "Live Tracking",
            subtitle: "Enable real-time route monitoring",
            value: liveTracking,
            onChanged: (value) {
              setState(() => liveTracking = value);
            },
          ),

          buildToggleTile(
            icon: Icons.notifications_active,
            title: "Emergency Alerts",
            subtitle: "Receive urgent security alerts",
            value: emergencyAlerts,
            onChanged: (value) {
              setState(() => emergencyAlerts = value);
            },
          ),

          const SizedBox(height: 28),

          const Text(
            "Personalization",
            style: TextStyle(
              color: Color(0xFFFF6FB8),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          buildToggleTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            subtitle: "Premium dark interface",
            value: darkMode,
            onChanged: (value) {
              setState(() => darkMode = value);
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme(value);
            },
          ),

          buildToggleTile(
            icon: Icons.visibility_off,
            title: "Ghost Mode Default",
            subtitle: "Enable stealth mode automatically",
            value: ghostModeDefault,
            onChanged: (value) {
              setState(() => ghostModeDefault = value);
            },
          ),

          const SizedBox(height: 28),

          const Text(
            "Account",
            style: TextStyle(
              color: Color(0xFFFF6FB8),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          buildActionTile(
            icon: Icons.lock,
            title: "Change Password",
            onTap: () {
              showMessage(
                "Password update coming soon",
                const Color(0xFFFF4FA3),
              );
            },
          ),

          buildActionTile(
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
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
