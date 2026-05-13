import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  // SIGNUP
  static Future<Map<String, dynamic>> signup(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // LOGIN
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"username": username, "password": password},
    );

    return jsonDecode(response.body);
  }

  // ADD CONTACT
  static Future<Map<String, dynamic>> addContact(
    String token,
    String name,
    String phone,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contacts/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"name": name, "phone": phone}),
    );

    return jsonDecode(response.body);
  }

  // GET CONTACTS
  static Future<List<dynamic>> getContacts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/contacts/'),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(response.body);
  }

  // DELETE CONTACT
  static Future<Map<String, dynamic>> deleteContact(
    String token,
    int contactId,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/contacts/$contactId'),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(response.body);
  }
}
