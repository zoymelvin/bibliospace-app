import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/book_model.dart';
import '../services/api_service.dart';

class BookRepository {
  late final Dio _dio;

  List<BookModel> _allBooksCache = [];
  final Set<String> _recordedTitles = {};
  bool _hasLoadedAllData = false;
  bool _isFetching = false;

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

  Future<List<BookModel>> searchBooks(String query) async {
    try {
      if (!_hasLoadedAllData && !_isFetching) {
         await _fetchAllPages();
      }
      final lowerQuery = query.toLowerCase();
      final results = _allBooksCache.where((book) {
        final title = book.title.toLowerCase();
        final author = book.author.toLowerCase();
        return title.contains(lowerQuery) || author.contains(lowerQuery);
      }).toList();

      return results;

    } catch (e) {
      log("Error Search Repository: $e");
      throw Exception('Gagal mencari buku: $e');
    }
  }

  Future<void> _fetchAllPages() async {
    _isFetching = true;
    int page = 1;
    bool hasMoreData = true;
    log("Mulai mengambil semua data buku untuk search index...");

    while (hasMoreData) {
      try {
        final response = await _dio.get('/api/v1/book?page=$page&limit=50');
        
        if (response.statusCode == 200) {
          var data = response.data;
          if (data is String) data = jsonDecode(data);
          
          List<dynamic> listData = [];
          if (data is Map<String, dynamic> && data.containsKey('books')) {
            listData = data['books'];
          } else if (data is List) {
            listData = data;
          }

          if (listData.isEmpty) {
            hasMoreData = false;
          } else {
            final parsedBooks = listData.map((json) => BookModel.fromJson(json)).toList();
            for (var book in parsedBooks) {
              if (!_recordedTitles.contains(book.title)) {
                _recordedTitles.add(book.title); 
                _allBooksCache.add(book);        
              }
            }

            page++; 
            log("Fetch page $page done. Total cached: ${_allBooksCache.length}");
          }
        } else {
          hasMoreData = false;
        }
      } catch (e) {
        log("Error fetching page $page: $e");
        hasMoreData = false; 
      }
    }

    _hasLoadedAllData = true;
    _isFetching = false;
    log("Selesai indexing. Total buku unik: ${_allBooksCache.length}");
  }
}