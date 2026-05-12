import 'package:flutter/material.dart';
import 'home_screen.dart';

class SetupCompleteScreen extends StatelessWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05060A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SUCCESS ICON
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4FA3).withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // TITLE
                  const Text(
                    "Setup Complete!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // SUBTITLE
                  const Text(
                    "Your safety circle is ready.\nWaitSafe is now prepared to protect you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFB8B8C5),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // FEATURES SUMMARY
                  Row(
                    children: const [
                      Expanded(
                        child: _FeatureTile(
                          icon: Icons.shield,
                          title: "Protection Active",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _FeatureTile(
                          icon: Icons.people,
                          title: "Trusted Circle Ready",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _FeatureTile(
                          icon: Icons.notifications_active,
                          title: "Alerts Enabled",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // GO HOME BUTTON
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
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "GO TO HOME",
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
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFFFF6FB8), size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
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
