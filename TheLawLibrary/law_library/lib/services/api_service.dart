import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:law_library/models/law.dart';
import 'package:law_library/models/user.dart';
import 'package:law_library/utils/constants.dart';
import 'package:law_library/utils/encryption.dart';
import 'package:logger/logger.dart'; // Make sure this package is in your pubspec.yaml

// Initialize logger with PrettyPrinter for readable output
var logger = Logger(
  printer: PrettyPrinter(),
);

class ApiService {
  // Base URL for API (from your constants file)
  final String baseUrl = ApiConstants.baseUrl;

  // New method to get the total count of laws
  Future<int> getTotalLawCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_law_count.php'),
      );

      logger.d('Get Total Law Count Response Status: ${response.statusCode}');
      logger.d('Get Total Law Count Response Body: "${response.body}"');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Received empty response body for total law count.');
        }
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return data['total_laws'] as int;
        } else {
          throw Exception(data['message'] ?? 'Failed to get total law count.');
        }
      } else {
        throw Exception(
            'Failed to load total law count: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Get Total Law Count Error: $e'); // Use logger.e for errors
      throw Exception('Failed to connect to server or get total law count: $e');
    }
  }

  // Get all laws with pagination
  Future<List<Law>> getLaws({
    int page = 1,
    int limit = 10,
    String? searchQuery,
    String? filterCategory,
  }) async {
    try {
      String url = '$baseUrl/get_laws.php?page=$page&limit=$limit';

      if (searchQuery != null && searchQuery.isNotEmpty) {
        url += '&search=$searchQuery';
      }

      if (filterCategory != null && filterCategory.isNotEmpty) {
        url += '&category=$filterCategory';
      }

      final response = await http.get(Uri.parse(url));

      logger.d('Get Laws Response Status: ${response.statusCode}');
      logger.d('Get Laws Response Body: "${response.body}"');

      if (response.statusCode == 200) {
        // Ensure the response is not empty before decoding
        if (response.body.isEmpty) {
          throw Exception('Received empty response body for laws.');
        }
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Law.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load laws: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Get Laws Error: $e'); // Use logger.e for errors
      throw Exception('Failed to connect to server or load laws: $e');
    }
  }

  // Get a single law by chapter
  Future<Law> getLawByChapter(String chapter) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_law.php?chapter=$chapter'),
      );

      logger.d('Get Law By Chapter Response Status: ${response.statusCode}');
      logger.d('Get Law By Chapter Response Body: "${response.body}"');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Received empty response body for law by chapter.');
        }
        return Law.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load law: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Get Law By Chapter Error: $e'); // Use logger.e for errors
      throw Exception('Failed to connect to server or load law: $e');
    }
  }

  // Get categories for filtering
  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_categories.php'),
      );

      logger.d('Get Categories Response Status: ${response.statusCode}');
      logger.d('Get Categories Response Body: "${response.body}"');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Received empty response body for categories.');
        }
        final List<dynamic> data = json.decode(response.body);
        // Assuming your PHP returns an array of objects like [{"Category": "Traffic"}],
        // and you want just the string value of the category.
        return data.map((item) => item['Category'] as String).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Get Categories Error: $e'); // Use logger.e for errors
      throw Exception('Failed to connect to server or load categories: $e');
    }
  }

  // Authentication
  Future<User?> login(String username, String password) async {
    try {
      // Encrypt password before sending
      final String hashedPassword = EncryptionUtil.hashPassword(password);

      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {
          'username': username,
          'password': hashedPassword,
        },
      );

      logger.d('Login Response Status: ${response.statusCode}');
      logger.d('Login Response Body: "${response.body}"');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Received empty response body for login.');
        }
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['user']);
        } else {
          // You might want to log the specific error message from the server here
          logger.d('Login failed: ${data['message']}');
          return null;
        }
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Login Error: $e'); // Use logger.e for errors
      throw Exception('Failed to connect to server or login: $e');
    }
  }

  // Admin CRUD operations
  Future<bool> createLaw(Law law) async {
    try {
      logger.d(
          'Create Law Request Body: ${law.toJson()}'); // Debug log for request

      final response = await http.post(
        Uri.parse('$baseUrl/create_law.php'),
        body: json.encode(law.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      // --- CRITICAL DEBUGGING LINES (placed immediately after response) ---
      logger.d('RAW Create Law Response Status: ${response.statusCode}');
      logger.d(
          'RAW Create Law Response Body: "${response.body}"'); // Print raw body as a string

      if (response.body.isEmpty) {
        throw Exception('Received empty response body from server.');
      }
      // This check will help catch non-JSON output early
      if (!response.body.startsWith('{') && !response.body.startsWith('[')) {
        throw Exception(
            'Received non-JSON response from server: ${response.body}');
      }
      // --- END CRITICAL DEBUGGING LINES ---

      final Map<String, dynamic> responseData = json.decode(response.body);
      return response.statusCode == 200 && responseData['success'] == true;

      // Check if the boolean value is true for success
    } catch (e) {
      logger.e('Create Law Error: $e'); // Use logger.e for errors
      throw Exception('Failed to create law: $e');
    }
  }

  // MODIFIED: Added originalChapter parameter to updateLaw and included it in the body
  Future<bool> updateLaw(Law law, {required String originalChapter}) async {
    try {
      // Use law.toJson() to send all relevant fields for update
      final Map<String, dynamic> requestBody = law.toJson();
      requestBody['Original_Chapter'] =
          originalChapter; // Add the original chapter

      logger.d('Update Law Request Body: $requestBody');
      logger.d('Sending to URL: $baseUrl/update_law.php');

      final response = await http.post(
        Uri.parse('$baseUrl/update_law.php'),
        body: json.encode(requestBody), // Encode the modified map
        headers: {'Content-Type': 'application/json'},
      );

      // --- CRITICAL DEBUGGING LINES (placed immediately after response) ---
      logger.d('RAW Update Law Response Status: ${response.statusCode}');
      logger.d(
          'RAW Update Law Response Body: "${response.body}"'); // Print raw body as a string

      if (response.body.isEmpty) {
        throw Exception('Received empty response body from server.');
      }
      if (!response.body.startsWith('{') && !response.body.startsWith('[')) {
        throw Exception(
            'Received non-JSON response from server: ${response.body}');
      }
      // --- END CRITICAL DEBUGGING LINES ---

      final Map<String, dynamic> responseData = json.decode(response.body);

      return response.statusCode == 200 && responseData['success'] == true;
    } catch (e) {
      logger.e('Update Law Error: $e'); // Use logger.e for errors
      throw Exception('Failed to update law: $e');
    }
  }

  // User management (admin only)
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_users.php'));
      logger.d('Get Users Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        if (response.body.isEmpty) throw Exception('Empty response');
        final Map<String, dynamic> body = json.decode(response.body);
        if (body['success'] != true) {
          throw Exception(body['message'] ?? 'Failed to load users');
        }
        final List<dynamic> data = body['users'] as List<dynamic>;
        return data.map((j) => User.fromJson(j)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Get Users Error: $e');
      throw Exception('Failed to load users: $e');
    }
  }

  Future<Map<String, dynamic>> createUser(
      String username, String hashedPassword, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_user.php'),
        body: {
          'username': username,
          'password': hashedPassword,
          'role': role,
        },
      );
      logger.d('Create User Response: ${response.body}');
      if (response.body.isEmpty) throw Exception('Empty response');
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      logger.e('Create User Error: $e');
      throw Exception('Failed to create user: $e');
    }
  }

  Future<Map<String, dynamic>> deleteUser(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete_user.php'),
        body: {'username': username},
      );
      logger.d('Delete User Response: ${response.body}');
      if (response.body.isEmpty) throw Exception('Empty response');
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      logger.e('Delete User Error: $e');
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<Map<String, dynamic>> resetUserPassword(
      String username, String hashedPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset_user_password.php'),
        body: {
          'username': username,
          'new_password': hashedPassword,
        },
      );
      logger.d('Reset Password Response: ${response.body}');
      if (response.body.isEmpty) throw Exception('Empty response');
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      logger.e('Reset Password Error: $e');
      throw Exception('Failed to reset password: $e');
    }
  }

  Future<bool> deleteLaw(String chapter) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete_law.php'),
        body: json.encode(
            {'Chapter': chapter}), // Use 'Chapter' to match Law.toJson()
        headers: {'Content-Type': 'application/json'},
      );

      logger.d(
          'Delete Law Request Body: {"Chapter": "$chapter"}'); // Updated log to match
      logger.d('Delete Law Response Status: ${response.statusCode}');
      logger.d('Delete Law Response Body: "${response.body}"');

      if (response.body.isEmpty) {
        throw Exception('Received empty response body for delete.');
      }
      if (!response.body.startsWith('{') && !response.body.startsWith('[')) {
        throw Exception(
            'Received non-JSON response from server: ${response.body}');
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (!responseData['success']) {
        throw Exception(responseData['message'] ?? 'Failed to delete law');
      }
      return response.statusCode == 200 && responseData['success'] == true;
    } catch (e) {
      logger.e('Delete Law Error: $e'); // Use logger.e for errors
      throw Exception('Failed to delete law: $e');
    }
  }
}