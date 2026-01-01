import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage( 
                    imageUrl: book.coverUrl, 
                    fit: BoxFit.cover,
                    width: double.infinity,
                    memCacheWidth: 200,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                          Text("No Cover", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Informasi Buku
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                
                  // Judul Buku
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13, 
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 5),
                  
                  // Genre Buku
                  Text(
                    book.genre.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9, 
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, 
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 8),

                  // Harga Buku
                  Text(
                    formatCurrency.format(book.price),
                    style: TextStyle(
                      fontSize: 13, 
                      color: Colors.blue[900], 
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}