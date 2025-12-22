import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/book_model.dart';
import '../services/api_service.dart';

class BookRepository {
  late final Dio _dio;

  BookRepository({ApiService? apiService}) {
    _dio = apiService?.client ?? Dio(BaseOptions(
      baseUrl: 'https://bukuacak-9bdcb4ef2605.herokuapp.com',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));
  }

  Future<List<BookModel>> getBooks({int page = 1}) async {
    try {
      final response = await _dio.get('/api/v1/book?page=$page&limit=10'); 

      if (response.statusCode == 200) {
        var data = response.data;
        if (data is String) data = jsonDecode(data);

        List<dynamic> listData = [];

        if (data is Map<String, dynamic> && data.containsKey('books')) {
           listData = data['books']; 
        } else if (data is List) {
           listData = data;
        } else {
           return []; 
        }

        return listData.map((json) => BookModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal ambil data. Code: ${response.statusCode}');
      }
    } catch (e) {
      log("Error Repository: $e");
      throw Exception('Gagal memuat buku: $e');
    }
  }
}