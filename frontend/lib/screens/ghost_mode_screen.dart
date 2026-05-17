import 'dart:async';
import 'package:flutter/material.dart';

class GhostModeScreen extends StatefulWidget {
  const GhostModeScreen({super.key});

  @override
  State<GhostModeScreen> createState() => _GhostModeScreenState();
}

class _GhostModeScreenState extends State<GhostModeScreen> {
  bool ghostModeEnabled = false;
  bool stealthTracking = true;
  int selectedMinutes = 15;

  Timer? ghostTimer;
  int remainingSeconds = 0;

  final List<int> timerOptions = [5, 10, 15, 20, 30, 45, 60];

  void startGhostMode() {
    ghostTimer?.cancel();

    setState(() {
      ghostModeEnabled = true;
      remainingSeconds = selectedMinutes * 60;
    });

    ghostTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Ghost timer expired. Silent emergency protocol activated.",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20),
          ),
        );

        setState(() {
          ghostModeEnabled = false;
        });
      }
    });
  }

  void stopGhostMode() {
    ghostTimer?.cancel();

    setState(() {
      ghostModeEnabled = false;
      remainingSeconds = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Ghost Mode safely disabled.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
      ),
    );
  }

  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    ghostTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF05060A)
          : const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          "Ghost Mode",
          style: TextStyle(
            color: Color(0xFFFF6FB8),
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark
            ? const Color(0xFF05060A)
            : const Color(0xFFF8F9FD),
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1100;

            if (!isDesktop) {
              return _buildMobileLayout(context, isDark);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildMainPanel(context, isDark),
                      ),

                      const SizedBox(width: 28),

                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildStatusCard(
                              icon: Icons.visibility_off,
                              title: "Invisible Mode",
                              subtitle: ghostModeEnabled
                                  ? "Stealth protection is currently active."
                                  : "Activate covert safety monitoring.",
                              color: ghostModeEnabled
                                  ? const Color(0xFFFF4FA3)
                                  : Colors.grey,
                            ),

                            const SizedBox(height: 22),

                            _buildStatusCard(
                              icon: Icons.location_searching,
                              title: "Silent Tracking",
                              subtitle: stealthTracking
                                  ? "Hidden route tracking is enabled."
                                  : "Silent route tracking disabled.",
                              color: stealthTracking
                                  ? Colors.green
                                  : Colors.grey,
                            ),

                            const SizedBox(height: 22),

                            _buildStatusCard(
                              icon: Icons.timer,
                              title: "Auto SOS Backup",
                              subtitle:
                                  "If your stealth timer expires, emergency response silently activates.",
                              color: Colors.orangeAccent,
                            ),

                            const SizedBox(height: 22),

                            _buildStatusCard(
                              icon: Icons.shield,
                              title: "Trusted Contact Shield",
                              subtitle:
                                  "Emergency circle stays alert without exposing active mode.",
                              color: const Color(0xFFB56CFF),
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

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 750),
          padding: const EdgeInsets.all(24),
          child: _buildMainPanel(context, isDark),
        ),
      ),
    );
  }

  Widget _buildMainPanel(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D14) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          Icon(
            ghostModeEnabled ? Icons.visibility_off : Icons.nightlight_round,
            size: 100,
            color: ghostModeEnabled
                ? const Color(0xFFFF4FA3)
                : const Color(0xFFB56CFF),
          ),

          const SizedBox(height: 25),

          Text(
            ghostModeEnabled ? "Ghost Mode Active" : "Stealth Protection",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            ghostModeEnabled
                ? "Invisible safety protocol running"
                : "Move quietly. Stay protected.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              color: Color(0xFFFF6FB8),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 34),

          Container(
            padding: const EdgeInsets.all(34),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF05060A) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: ghostModeEnabled
                    ? const Color(0xFFFF4FA3).withOpacity(0.4)
                    : const Color(0xFFB56CFF).withOpacity(0.4),
              ),
            ),
            child: Column(
              children: [
                Text(
                  ghostModeEnabled ? "Stealth Countdown" : "Set Ghost Timer",
                  style: TextStyle(
                    fontSize: 20,
                    color: ghostModeEnabled
                        ? const Color(0xFFFF4FA3)
                        : const Color(0xFFB56CFF),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  ghostModeEnabled ? formattedTime : "$selectedMinutes min",
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: ghostModeEnabled
                        ? const Color(0xFFFF4FA3)
                        : const Color(0xFFB56CFF),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          if (!ghostModeEnabled)
            DropdownButtonFormField<int>(
              value: selectedMinutes,
              dropdownColor: const Color(0xFF0B0D14),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF05060A),
                labelText: "Stealth Duration",
                labelStyle: const TextStyle(color: Color(0xFFFF6FB8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              items: timerOptions.map((minutes) {
                return DropdownMenuItem(
                  value: minutes,
                  child: Text(
                    "$minutes minutes",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedMinutes = value;
                  });
                }
              },
            ),

          const SizedBox(height: 18),

          SwitchListTile(
            value: stealthTracking,
            onChanged: (value) {
              setState(() {
                stealthTracking = value;
              });
            },
            activeColor: const Color(0xFFFF4FA3),
            title: const Text(
              "Enable Silent Tracking",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "Hidden route visibility for emergency fallback",
              style: TextStyle(color: Color(0xFFB8B8C5)),
            ),
          ),

          const SizedBox(height: 30),

          if (!ghostModeEnabled)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: startGhostMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4FA3),
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "ACTIVATE GHOST MODE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          if (ghostModeEnabled)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: stopGhostMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "END GHOST MODE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D14),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 34),
          ),

          const SizedBox(height: 20),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
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
