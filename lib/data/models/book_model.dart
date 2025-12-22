import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String title;
  final String author;
  final String synopsis;
  final String coverUrl;
  final int publicationYear;
  final String genre;
  final int price;

  const BookModel({
    required this.title,
    required this.author,
    required this.synopsis,
    required this.coverUrl,
    required this.publicationYear,
    required this.genre,
    required this.price,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    // 1. Ambil Penulis
    String authorName = 'Penulis Tidak Diketahui';
    if (json['author'] != null && json['author'] is Map) {
      authorName = json['author']['name'] ?? authorName;
    }

    // 2. Ambil Harga
    int parsedPrice = 0;
    try {
      if (json['details'] != null && json['details']['price'] != null) {
        String priceString = json['details']['price'].toString();
        String cleanPrice = priceString.replaceAll(RegExp(r'[^0-9]'), '');
        parsedPrice = int.tryParse(cleanPrice) ?? 0;
      }
    } catch (e) {
      parsedPrice = 0;
    }

    // 3. Ambil Tahun Terbit
    int year = 2024;
    try {
       if (json['details'] != null && json['details']['published_date'] != null) {
         String date = json['details']['published_date'].toString();
         year = int.tryParse(date.split(' ').last) ?? 2024;
       }
    } catch (_) {}

    return BookModel(
      title: json['title'] ?? 'Tanpa Judul',
      author: authorName,
      synopsis: json['summary'] ?? 'Tidak ada sinopsis.',
      coverUrl: json['cover_image'] ?? 'https://via.placeholder.com/150',
      publicationYear: year,
      genre: (json['category'] != null) ? json['category']['name'] : 'Umum',
      price: parsedPrice,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'summary': synopsis,
      'cover_image': coverUrl,
      'year': publicationYear,
      'genre': genre,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [title, author, publicationYear, genre, price];
}