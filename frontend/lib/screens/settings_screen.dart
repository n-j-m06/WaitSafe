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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
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
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF05060A),
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF9B9BA5) : Colors.black54,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF6FB8)),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF05060A),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("App Settings"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 750),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.settings,
                      size: 90,
                      color: Color(0xFFFF4FA3),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      "Control Your Safety Experience",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF05060A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "Customize security, privacy, and account preferences",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? const Color(0xFFB8B8C5)
                            : Colors.black54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  const Text(
                    "Security",
                    style: TextStyle(
                      color: Color(0xFFFF6FB8),
                      fontSize: 22,
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
                      fontSize: 22,
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
                      fontSize: 22,
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
            ),
          ),
        ),
      ),
    );
  }
}
