import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/configs/theme.dart';

class CollectionBookCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isExpired;
  final VoidCallback? onRentAgain;

  const CollectionBookCard({
    super.key,
    required this.data,
    this.isExpired = false,
    this.onRentAgain,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil data  transaksi
    final String title = data['book_title'] ?? 'Tanpa Judul';
    final String author = data['book_author'] ?? 'Penulis Tidak Diketahui';
    final String coverUrl = data['book_cover'] ?? '';
    final String type = data['type'] ?? 'purchase';
    
    // Logika status
    final bool isPurchase = type == 'purchase';
    
    // Format tanggal
    final String dateString = isPurchase ? data['created_at'] : data['return_date'];
    final DateTime date = DateTime.parse(dateString);
    final String formattedDate = DateFormat('dd MMM yyyy').format(date);

    // Hitung sisa waktu
    String timeLeft = "";
    if (!isPurchase && !isExpired) {
      final Duration diff = date.difference(DateTime.now());
      if (diff.inDays > 0) {
        timeLeft = "Sisa ${diff.inDays} Hari";
      } else {
        timeLeft = "Sisa ${diff.inHours} Jam";
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Cover buku
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ColorFiltered(
              colorFilter: isExpired 
                  ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                  : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
              child: CachedNetworkImage(
                imageUrl: coverUrl,
                width: 70,
                height: 100,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.book)),
              ),
            ),
          ),
          
          const SizedBox(width: 16),

          // INfo buku
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status buku
                if (isPurchase)
                  _buildBadge("MILIK PERMANEN", Colors.green)
                else if (isExpired)
                  _buildBadge("SEWA BERAKHIR", Colors.red)
                else
                  _buildBadge("SEWA AKTIF", const Color.fromARGB(255, 110, 137, 224)),

                const SizedBox(height: 8),
                
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isExpired ? Colors.grey : Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  author,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 8),

                
                if (isExpired)
                  // Tombol sewa lagi
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: onRentAgain,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryBlue),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("SEWA LAGI", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  
                  Row(
                    children: [
                      Icon(
                        isPurchase ? Icons.calendar_today : Icons.timer,
                        size: 14,
                        color: isPurchase ? Colors.green : const Color.fromARGB(255, 110, 137, 224),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isPurchase ? "Dibeli: $formattedDate" : "$timeLeft ($formattedDate)",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isPurchase ? Colors.green[700] : const Color.fromARGB(255, 110, 137, 224),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}