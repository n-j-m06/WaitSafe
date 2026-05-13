import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'setup_complete_screen.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<Map<String, String>> contacts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> loadContacts() async {
    try {
      final token = await getToken();

      if (token == null) return;

      final response = await ApiService.getContacts(token);

      setState(() {
        contacts = response.map<Map<String, String>>((contact) {
          return {
            "id": contact["id"].toString(),
            "name": contact["name"].toString(),
            "phone": contact["phone"].toString(),
          };
        }).toList();
      });
    } catch (e) {
      showSnack("Failed to load contacts", Colors.redAccent);
    }
  }

  Future<void> addContact() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      showSnack("Please fill all contact details", const Color(0xFFFF4FA3));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token = await getToken();

      if (token == null) {
        showSnack("Login session expired", Colors.redAccent);
        return;
      }

      final response = await ApiService.addContact(
        token,
        nameController.text.trim(),
        phoneController.text.trim(),
      );

      if (response.containsKey("id") || response.containsKey("name")) {
        nameController.clear();
        phoneController.clear();

        await loadContacts();

        showSnack("Emergency Contact Added", Colors.green);
      } else {
        showSnack("Failed to add contact", Colors.redAccent);
      }
    } catch (e) {
      showSnack("Server Error: $e", Colors.redAccent);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteContact(int index) async {
    try {
      final token = await getToken();

      if (token == null) {
        showSnack("Login session expired", Colors.redAccent);
        return;
      }

      final contactId = int.parse(contacts[index]["id"]!);

      final response = await ApiService.deleteContact(token, contactId);

      if (response["message"] != null) {
        await loadContacts();
        showSnack("Contact deleted successfully", Colors.green);
      } else {
        showSnack("Failed to delete contact", Colors.redAccent);
      }
    } catch (e) {
      showSnack("Server Error: $e", Colors.redAccent);
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
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF05060A)
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF05060A)
            : Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF05060A),
        ),
        title: const Text(
          "Emergency Contacts",
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
                  const Icon(
                    Icons.contact_phone,
                    size: 90,
                    color: Color(0xFFFF4FA3),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Your Trusted Safety Circle",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF05060A),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Add people who should be alerted during emergencies",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFB8B8C5) : Colors.black54,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 35),

                  _buildField(
                    context: context,
                    controller: nameController,
                    hint: "Contact Name",
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 18),

                  _buildField(
                    context: context,
                    controller: phoneController,
                    hint: "Phone Number",
                    icon: Icons.phone,
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4FA3).withValues(alpha: 0.4),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : addContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "ADD CONTACT",
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

                  if (contacts.isNotEmpty)
                    Column(
                      children: contacts.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> contact = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0B0D14)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0x22FF4FA3)),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0x22FF4FA3),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFFFF6FB8),
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact["name"] ?? "",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF05060A),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      contact["phone"] ?? "",
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFB8B8C5)
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                onPressed: () => deleteContact(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF4FA3), Color(0xFFFF85C8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4FA3).withValues(alpha: 0.4),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (contacts.isEmpty) {
                          showSnack(
                            "Add at least one emergency contact",
                            const Color(0xFFFF4FA3),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SetupCompleteScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "FINISH SETUP",
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
      keyboardType: hint == "Phone Number"
          ? TextInputType.phone
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF9B9BA5) : Colors.black45,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFFF6FB8)),
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
}
