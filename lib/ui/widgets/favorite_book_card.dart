import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavoriteBookCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const FavoriteBookCard({
    super.key,
    required this.data,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Extract Data
    final String title = data['title'] ?? 'Tanpa Judul';
    final String author = data['author'] ?? 'Penulis --';
    final String coverUrl = data['cover_url'] ?? '';
    final String genre = data['genre'] ?? 'Umum';
    final String synopsis = data['synopsis'] ?? 'Tidak ada sinopsis.';
    final double rating = (data['rating'] ?? 4.5).toDouble();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 170, // Tinggi kartu landscape
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. COVER BUKU (KIRI)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: coverUrl,
                width: 110,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: Colors.grey[200]),
                errorWidget: (c, u, e) => const Icon(Icons.broken_image),
              ),
            ),

            // 2. DETAIL (KANAN)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating & Genre Chips
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 12, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(genre.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Judul
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    
                    Text(
                      author,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Cuplikan Sinopsis
                    Expanded(
                      child: Text(
                        synopsis,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.4),
                      ),
                    ),

                    // Tombol Hapus Kecil
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.shade100),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete_outline, size: 14, color: Colors.red[400]),
                              const SizedBox(width: 4),
                              Text("Hapus", style: TextStyle(fontSize: 11, color: Colors.red[400])),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}