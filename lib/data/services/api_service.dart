import 'dart:developer';
import 'package:dio/dio.dart';

class ApiService {
  late final Dio client;

  ApiService() {
    client = Dio(BaseOptions(
      baseUrl: 'https://bukuacak-9bdcb4ef2605.herokuapp.com',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));
  }

  Future<Response> getBooks() async {
    try {
      log('API Request: GET /books');

      final response = await client.get('/books');

      log('API Response: ${response.statusCode}');
      return response;
    } catch (e) {
      log('API Error (getBooks): $e');
      rethrow;
    }
  }

  Future<Response> login(String email, String password) async {
    try {
      log('API Request: POST /login | Email: $email');

      final response = await client.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      log('API Response (Login): ${response.statusCode}');
      return response;
    } catch (e) {
      log('API Error (Login): $e');
      rethrow;
    }
  }

  Future<Response> register(String name, String email, String password) async {
    try {
      log('API Request: POST /register | Email: $email');

      final response = await client.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      log('API Response (Register): ${response.statusCode}');
      return response;
    } catch (e) {
      log('API Error (Register): $e');
      rethrow;
    }
  }
}