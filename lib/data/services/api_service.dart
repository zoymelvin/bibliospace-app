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
}