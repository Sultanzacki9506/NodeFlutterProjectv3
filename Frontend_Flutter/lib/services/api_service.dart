import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  // final String baseUrl = "http://10.0.2.2:3000";
  // final String baseUrlNlp = "http://10.0.2.2:8000";

  final String baseUrl = "http://192.168.100.222:3000";
  final String baseUrlNlp = "http://192.168.100.222:8000";

  Future<String> askChatbot(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrlNlp/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        return "Maaf, server sedang sibuk.";
      }
    } catch (e) {
      debugPrint('Error during askChatbot: $e');
      return "Gagal terhubung ke chatbot.";
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          return token;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error during login: $e');
      return null;
    }
  }

  Future<List> fetchSampah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        debugPrint('Token tidak ditemukan, silakan login kembali.');
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/sampah'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint(
          'Gagal mengambil data sampah. Status: ${response.statusCode}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching sampah: $e');
      return [];
    }
  }

  Future<bool> deleteSampah(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('$baseUrl/sampah/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error deleting sampah: $e');
      return false;
    }
  }

  Future<bool> saveSampah(String nama, File? image, {int? id}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return false;

      final url = Uri.parse(
        id == null ? '$baseUrl/sampah' : '$baseUrl/sampah/$id',
      );
      var request = http.MultipartRequest(id == null ? 'POST' : 'PUT', url);

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['nama_sampah'] = nama;

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'pic',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('Error saving sampah: $e');
      return false;
    }
  }
}
