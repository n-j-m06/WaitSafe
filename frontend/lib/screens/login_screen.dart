import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> handleAuth() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showSnack("Please fill all fields", Colors.redAccent);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> response;

      if (isLogin) {
        response = await ApiService.login(username, password);

        if (response.containsKey("access_token")) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", response["access_token"]);

          if (!mounted) return;

          showSnack("Login Successful", Colors.green);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          showSnack(
            response["detail"]?.toString() ?? "Login Failed",
            Colors.redAccent,
          );
        }
      } else {
        response = await ApiService.signup(username, password);

        if (response.containsKey("id")) {
          showSnack("Signup Successful. Please Login.", Colors.green);

          setState(() {
            isLogin = true;
          });
        } else {
          showSnack(
            response["detail"]?.toString() ?? "Signup Failed",
            Colors.redAccent,
          );
        }
      }
    } catch (e) {
      showSnack("Server Error: $e", Colors.redAccent);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showSnack(String message, Color color) {
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
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF05060A) : const Color(0xFFF8F9FD);

    final cardColor = isDark ? const Color(0xFF0B0D14) : Colors.white;

    final primaryText = isDark ? Colors.white : const Color(0xFF1A1A1A);

    final secondaryText = isDark
        ? const Color(0xFFB8B8C5)
        : const Color(0xFF5F6368);

    final fieldFill = isDark
        ? const Color(0xFF11131A)
        : const Color(0xFFF3F4F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 760),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 220,
                        width: 220,
                        child: Lottie.asset(
                          'assets/animations/girls_talking.json',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFFFFFFF),
                                  Color(0xFFFF4FA3),
                                  Color(0xFFFF85C8),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                "WaitSafe",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 72,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 12,
                                      color: Color(0xFFFF4FA3),
                                    ),
                                    Shadow(
                                      blurRadius: 28,
                                      color: Color(0x66FF4FA3),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              isLogin
                                  ? "Secure your journey. Login now."
                                  : "Create your safety network account.",
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 42),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFFF4FA3,
                          ).withValues(alpha: isDark ? 0.20 : 0.10),
                          blurRadius: 26,
                        ),
                      ],
                      border: Border.all(color: const Color(0x22FF4FA3)),
                    ),
                    child: Column(
                      children: [
                        _buildField(
                          controller: usernameController,
                          hint: "Username",
                          icon: Icons.person,
                          fillColor: fieldFill,
                          textColor: primaryText,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 18),

                        _buildField(
                          controller: passwordController,
                          hint: "Password",
                          icon: Icons.lock,
                          fillColor: fieldFill,
                          textColor: primaryText,
                          isDark: isDark,
                          obscure: obscurePassword,
                          suffix: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFFFF6FB8),
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 28),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF4FA3,
                                ).withValues(alpha: 0.40),
                                blurRadius: 22,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading ? null : handleAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    isLogin ? "LOGIN" : "SIGN UP",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin
                                ? "New user? Sign Up"
                                : "Already have an account? Login",
                            style: const TextStyle(
                              color: Color(0xFFFF4FA3),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color fillColor,
    required Color textColor,
    required bool isDark,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF9B9BA5) : const Color(0xFF7A7A85),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFFF6FB8)),
        suffixIcon: suffix,
        filled: true,
        fillColor: fillColor,
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
}
