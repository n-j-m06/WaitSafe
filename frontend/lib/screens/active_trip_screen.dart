import 'dart:async';
import 'package:flutter/material.dart';

class ActiveTripScreen extends StatefulWidget {
  final String destination;
  final int durationMinutes;
  final String emergencyContact;
  final bool liveTracking;

  const ActiveTripScreen({
    super.key,
    required this.destination,
    required this.durationMinutes,
    required this.emergencyContact,
    required this.liveTracking,
  });

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  late int remainingSeconds;
  Timer? countdownTimer;
  bool tripCompleted = false;
  bool emergencyTriggered = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.durationMinutes * 60;
    startTimer();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        triggerEmergency(autoTriggered: true);
      }
    });
  }

  void triggerEmergency({bool autoTriggered = false}) {
    if (tripCompleted || emergencyTriggered) return;

    countdownTimer?.cancel();

    setState(() {
      emergencyTriggered = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          autoTriggered
              ? "Timer expired. Emergency alert triggered."
              : "Panic alert triggered successfully",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void markSafe() {
    countdownTimer?.cancel();

    setState(() {
      tripCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Trip completed safely!",
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

  String get journeyStatus {
    if (emergencyTriggered) return "Emergency Triggered";
    if (tripCompleted) return "Journey Completed";
    return "Safe Walk Active";
  }

  Color get statusColor {
    if (emergencyTriggered) return Colors.redAccent;
    if (tripCompleted) return Colors.green;
    return const Color(0xFFFF4FA3);
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
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
          "Active Safe Walk",
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
                              icon: Icons.shield,
                              title: "Journey Status",
                              subtitle: journeyStatus,
                              color: statusColor,
                            ),

                            const SizedBox(height: 22),

                            _buildStatusCard(
                              icon: Icons.groups,
                              title: "Trusted Circle",
                              subtitle:
                                  "Emergency contacts are connected and alert-ready.",
                              color: const Color(0xFFFF6FB8),
                            ),

                            const SizedBox(height: 22),

                            _buildStatusCard(
                              icon: Icons.timer,
                              title: "Auto SOS Protection",
                              subtitle: tripCompleted
                                  ? "Journey safely completed."
                                  : emergencyTriggered
                                  ? "Emergency protocol activated."
                                  : "If timer expires, SOS activates automatically.",
                              color: emergencyTriggered
                                  ? Colors.redAccent
                                  : Colors.orangeAccent,
                            ),

                            const SizedBox(height: 22),

                            _buildStatusCard(
                              icon: Icons.location_history,
                              title: "Live Tracking",
                              subtitle: widget.liveTracking
                                  ? "Your movement tracking is enabled."
                                  : "Tracking is disabled.",
                              color: widget.liveTracking
                                  ? Colors.green
                                  : Colors.grey,
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
            emergencyTriggered
                ? Icons.warning_rounded
                : tripCompleted
                ? Icons.verified_user
                : Icons.shield_moon,
            size: 100,
            color: statusColor,
          ),

          const SizedBox(height: 25),

          Text(
            journeyStatus,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            widget.destination,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
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
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Text(
                  emergencyTriggered
                      ? "Emergency Activated"
                      : tripCompleted
                      ? "Journey Secured"
                      : "Remaining Time",
                  style: TextStyle(fontSize: 20, color: statusColor),
                ),

                const SizedBox(height: 14),

                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          _infoTile(
            icon: Icons.phone,
            title: widget.emergencyContact,
            subtitle: "Emergency Contact",
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _infoTile(
            icon: Icons.location_history,
            title: widget.liveTracking ? "Enabled" : "Disabled",
            subtitle: "Live Tracking",
            isDark: isDark,
          ),

          const SizedBox(height: 30),

          if (!tripCompleted && !emergencyTriggered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => triggerEmergency(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "PANIC SOS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          if (!tripCompleted && !emergencyTriggered) const SizedBox(height: 18),

          if (!tripCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: markSafe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "I'M SAFE",
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

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF05060A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22FF4FA3)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF6FB8)),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
          ),
        ),
        subtitle: Text(subtitle),
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
