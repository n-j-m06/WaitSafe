import 'package:flutter/material.dart';

class GhostModeScreen extends StatefulWidget {
  const GhostModeScreen({super.key});

  @override
  State<GhostModeScreen> createState() => _GhostModeScreenState();
}

class _GhostModeScreenState extends State<GhostModeScreen> {
  final TextEditingController fakeDestinationController =
      TextEditingController();

  bool decoyCalls = true;
  bool hiddenTracking = true;
  bool panicMode = false;

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
          "Ghost Mode",
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
              constraints: const BoxConstraints(maxWidth: 760),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.visibility_off_rounded,
                    size: 95,
                    color: Color(0xFFFF4FA3),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Disappear. Divert. Defend.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF05060A),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Create decoy routes, hide your real movement,\nand activate stealth safety protocols.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFB8B8C5) : Colors.black54,
                      fontSize: 17,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // FAKE DESTINATION
                  _buildField(
                    context: context,
                    controller: fakeDestinationController,
                    hint: "Set Fake Destination",
                    icon: Icons.alt_route,
                  ),

                  const SizedBox(height: 28),

                  // TOGGLES
                  _buildToggleCard(
                    context: context,
                    title: "Decoy Calls",
                    subtitle: "Simulate fake incoming safety calls",
                    value: decoyCalls,
                    onChanged: (value) {
                      setState(() {
                        decoyCalls = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildToggleCard(
                    context: context,
                    title: "Hidden Tracking",
                    subtitle: "Share real route silently with trusted circle",
                    value: hiddenTracking,
                    onChanged: (value) {
                      setState(() {
                        hiddenTracking = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildToggleCard(
                    context: context,
                    title: "Panic Trigger",
                    subtitle: "Emergency stealth SOS if danger detected",
                    value: panicMode,
                    onChanged: (value) {
                      setState(() {
                        panicMode = value;
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  // ACTIVATE BUTTON
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
                        if (fakeDestinationController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Set a fake destination first",
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
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Ghost Mode Activated",
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
                            ),
                          );
                        }
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
                        "ACTIVATE GHOST MODE",
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

                  // FEATURES
                  Row(
                    children: [
                      Expanded(
                        child: _GhostFeature(
                          icon: Icons.call,
                          title: "Fake Call Shield",
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _GhostFeature(
                          icon: Icons.location_off,
                          title: "Route Masking",
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _GhostFeature(
                          icon: Icons.warning_amber,
                          title: "Silent SOS",
                          isDark: isDark,
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
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF05060A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF9B9BA5) : Colors.black45,
        ),
        prefixIcon: const Icon(Icons.alt_route, color: Color(0xFFFF6FB8)),
        filled: true,
        fillColor: isDark ? const Color(0xFF0B0D14) : Colors.white,
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

  Widget _buildToggleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFF4FA3),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF05060A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark ? const Color(0xFF9B9BA5) : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _GhostFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;

  const _GhostFeature({
    required this.icon,
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF6FB8), size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF05060A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
