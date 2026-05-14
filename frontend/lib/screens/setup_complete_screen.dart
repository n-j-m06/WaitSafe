import 'package:flutter/material.dart';
import 'home_screen.dart';

class SetupCompleteScreen extends StatelessWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 1000;

    return Scaffold(
      backgroundColor: const Color(0xFF05060A),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 900,
                    maxWidth: double.infinity,
                  ),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _buildMainPanel(context)),
                            const SizedBox(width: 35),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: const [
                                  _DesktopFeatureCard(
                                    icon: Icons.shield,
                                    title: "Protection Active",
                                    subtitle:
                                        "Your safety system is now live and ready.",
                                  ),
                                  SizedBox(height: 24),
                                  _DesktopFeatureCard(
                                    icon: Icons.people,
                                    title: "Trusted Circle Ready",
                                    subtitle:
                                        "Emergency contacts are configured and prepared.",
                                  ),
                                  SizedBox(height: 24),
                                  _DesktopFeatureCard(
                                    icon: Icons.notifications_active,
                                    title: "Alerts Enabled",
                                    subtitle:
                                        "Instant SOS and live alerts are activated.",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: SizedBox(
                            width: 700,
                            child: _buildMainPanel(context),
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x22FF4FA3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4FA3).withOpacity(0.14),
            blurRadius: 34,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4FA3).withOpacity(0.45),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.verified_user,
              color: Colors.white,
              size: 90,
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            "Setup Complete!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 54,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Your safety circle is ready.\nWaitSafe is now prepared to protect you.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFB8B8C5),
              height: 1.7,
            ),
          ),

          const SizedBox(height: 45),

          Row(
            children: const [
              Expanded(
                child: _FeatureTile(
                  icon: Icons.shield,
                  title: "Protection Active",
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _FeatureTile(
                  icon: Icons.people,
                  title: "Trusted Circle Ready",
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _FeatureTile(
                  icon: Icons.notifications_active,
                  title: "Alerts Enabled",
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4FA3).withOpacity(0.42),
                  blurRadius: 24,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                "GO TO HOME",
                style: TextStyle(
                  fontSize: 24,
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
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF05060A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF6FB8), size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DesktopFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 28),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0x22FF4FA3),
            child: Icon(icon, color: const Color(0xFFFF6FB8), size: 36),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFFB8B8C5),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
