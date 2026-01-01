import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String title;
  final String author;
  final String synopsis;
  final String coverUrl;
  final int publicationYear;
  final String genre;
  final int price;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.synopsis,
    required this.coverUrl,
    required this.publicationYear,
    required this.genre,
    required this.price,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {

    // ID
    String bookId = json['id'] != null ? json['id'].toString() : 'id_tidak_diketahui';
    
    // Penulis
    String authorName = 'Penulis Tidak Diketahui';
    if (json['author'] != null) {
       if (json['author'] is Map) {
          authorName = json['author']['name'] ?? authorName;
       } else if (json['author'] is String) {
          authorName = json['author'];
       }
    }

    // Harga 
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

    // Tahun Terbit
    int year = 2024;
    try {
       if (json['details'] != null && json['details']['published_date'] != null) {
         String date = json['details']['published_date'].toString();
         RegExp regExp = RegExp(r'\d{4}');
         Match? match = regExp.firstMatch(date);
         if (match != null) {
           year = int.parse(match.group(0)!);
         }
       }
    } catch (_) {}

    // Genre
    String genreName = 'Umum';
    if (json['category'] != null) {
        if (json['category'] is Map) {
            genreName = json['category']['name'] ?? 'Umum';
        } else if (json['category'] is String) {
            genreName = json['category'];
        }
    }

    return BookModel(
      id: bookId,
      title: json['title'] ?? 'Tanpa Judul',
      author: authorName,
      synopsis: json['summary'] ?? 'Tidak ada sinopsis.',
      coverUrl: json['cover_image'] ?? 'https://via.placeholder.com/150',
      publicationYear: year,
      genre: genreName,
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