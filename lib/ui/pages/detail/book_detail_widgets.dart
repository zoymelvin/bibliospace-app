import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/configs/theme.dart';
import '../../../data/models/book_model.dart';

// WIDGET COVER BUKU
class BookCoverSection extends StatelessWidget {
  final String coverUrl;
  final String title;

  const BookCoverSection({super.key, required this.coverUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170, 
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), 
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Hero(
            tag: title,
            child: CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[100]),
              errorWidget: (context, url, error) => const Icon(Icons.broken_image),
            ),
          ),
        ),
      ),
    );
  }
}

// WIDGET INFO BUKU
class BookInfoSection extends StatelessWidget {
  final BookModel book;
  final bool isWatchlist;
  final VoidCallback onWatchlistTap;

  const BookInfoSection({
    super.key, 
    required this.book, 
    required this.isWatchlist, 
    required this.onWatchlistTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                book.genre.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // Watchlist Button
            InkWell(
              onTap: onWatchlistTap,
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  isWatchlist ? Icons.bookmark : Icons.bookmark_border,
                  color: isWatchlist ? AppTheme.primaryBlue : Colors.grey,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),

        // Judul Buku
        Text(
          book.title,
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
        
        const SizedBox(height: 6),
        
        // Penulis & Tahun
        Row(
          children: [
            Text(
              book.author,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(width: 8),
            const Text("•", style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 8),
            Text(
              "${book.publicationYear}",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}

// WIDGET SINOPSIS
class BookSynopsisSection extends StatefulWidget {
  final String synopsis;

  const BookSynopsisSection({super.key, required this.synopsis});

  @override
  State<BookSynopsisSection> createState() => _BookSynopsisSectionState();
}

class _BookSynopsisSectionState extends State<BookSynopsisSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sinopsis",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87
          ),
        ),
        const SizedBox(height: 8),

        AnimatedCrossFade(
          firstChild: Text(
            widget.synopsis,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          secondChild: Text(
            widget.synopsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),

        const SizedBox(height: 6),

        // Tombol Baca Selengkapnya
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "Lebih Sedikit" : "Baca Selengkapnya",
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

// WIDGET BOTTOM BAR
class BookBottomBar extends StatelessWidget {
  final int price;
  final VoidCallback onBuy;
  final VoidCallback onRent;

  const BookBottomBar({
    super.key, 
    required this.price, 
    required this.onBuy, 
    required this.onRent
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    const double rentPrice = 5000; 

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Harga Beli", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                Text(
                  currencyFormatter.format(price),
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          
          OutlinedButton(
            onPressed: onRent,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.primaryBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(
              "Sewa ${currencyFormatter.format(rentPrice)}",
              style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          
          const SizedBox(width: 10),
          
          ElevatedButton(
            onPressed: onBuy,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 0,
            ),
            child: const Text(
              "Beli Buku",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}