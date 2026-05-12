import 'package:flutter/material.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF05060A),
        ),
        title: const Text(
          "My Profile",
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
              constraints: const BoxConstraints(maxWidth: 750),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // PROFILE HEADER
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0B0D14) : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0x22FF4FA3)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFFF4FA3,
                          ).withOpacity(isDark ? 0.15 : 0.08),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF4FA3).withOpacity(0.5),
                                blurRadius: 18,
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: isDark
                                ? const Color(0xFF05060A)
                                : Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 52,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF05060A),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "Ami User",
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF05060A),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
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

                        Text(
                          "Your safety network is active and secured.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFFB8B8C5)
                                : Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // STATS
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.route,
                          count: "24",
                          label: "Saved Trips",
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.groups,
                          count: "5",
                          label: "Trusted Contacts",
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.visibility_off,
                          count: "12",
                          label: "Ghost Uses",
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ACTION BUTTONS
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildActionButton(
                    context: context,
                    icon: Icons.settings,
                    title: "App Settings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

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
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x44FF4FA3)),
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFFFF6FB8)),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF05060A),
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
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF6FB8), size: 30),

          const SizedBox(height: 12),

          Text(
            count,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF05060A),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? const Color(0xFFB8B8C5) : Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
