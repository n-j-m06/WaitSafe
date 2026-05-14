import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

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
  bool isPanicLoading = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.durationMinutes * 60;
    startTimer();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        await triggerTimerEmergency();
      }
    });
  }

  Future<void> triggerTimerEmergency() async {
    if (tripCompleted) return;

    final token = await getToken();

    if (token == null) {
      showSnack("Login expired. Please login again.", Colors.redAccent);
      return;
    }

    try {
      final response = await ApiService.triggerTimerAlert(token);

      setState(() {
        emergencyTriggered = true;
      });

      showSnack(
        response["message"] ??
            "Timer expired. Emergency alert sent to trusted contacts.",
        Colors.redAccent,
      );
    } catch (e) {
      showSnack("Timer SOS failed: $e", Colors.redAccent);
    }
  }

  Future<void> triggerPanicAlert() async {
    final token = await getToken();

    if (token == null) {
      showSnack("Login expired. Please login again.", Colors.redAccent);
      return;
    }

    setState(() {
      isPanicLoading = true;
    });

    try {
      final response = await ApiService.triggerPanic(token);

      setState(() {
        emergencyTriggered = true;
      });

      showSnack(
        response["message"] ?? "Panic alert triggered successfully",
        Colors.redAccent,
      );
    } catch (e) {
      showSnack("Panic failed: $e", Colors.redAccent);
    } finally {
      setState(() {
        isPanicLoading = false;
      });
    }
  }

  void markSafe() {
    countdownTimer?.cancel();

    setState(() {
      tripCompleted = true;
    });

    showSnack("Trip completed safely!", Colors.green);
  }

  void showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 4),
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
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Icon(
                    emergencyTriggered
                        ? Icons.warning_rounded
                        : Icons.shield_moon,
                    size: 100,
                    color: emergencyTriggered
                        ? Colors.redAccent
                        : const Color(0xFFFF4FA3),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    emergencyTriggered
                        ? "Emergency Triggered"
                        : tripCompleted
                        ? "Journey Completed"
                        : "Safe Walk Active",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    widget.destination,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xFFFF6FB8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0B0D14) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: emergencyTriggered
                            ? Colors.redAccent
                            : const Color(0x22FF4FA3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          emergencyTriggered
                              ? "Emergency Activated"
                              : "Remaining Time",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFFFF6FB8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            color: emergencyTriggered
                                ? Colors.redAccent
                                : (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0B0D14) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0x22FF4FA3)),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: Color(0xFFFF6FB8),
                      ),
                      title: Text(
                        widget.emergencyContact,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: const Text("Emergency Contact"),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0B0D14) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0x22FF4FA3)),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_history,
                        color: Color(0xFFFF6FB8),
                      ),
                      title: Text(
                        widget.liveTracking ? "Enabled" : "Disabled",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: const Text("Live Tracking"),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (!tripCompleted && !emergencyTriggered) ...[
                    // PANIC BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isPanicLoading ? null : triggerPanicAlert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: isPanicLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "PANIC SOS",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // SAFE BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: markSafe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "I'M SAFE",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
