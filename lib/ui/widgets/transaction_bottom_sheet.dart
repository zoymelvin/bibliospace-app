import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/book_model.dart';

class TransactionBottomSheet extends StatefulWidget {
  final BookModel book;
  final bool isRent;
  final Function(int duration, int totalPrice) onConfirm;

  const TransactionBottomSheet({
    super.key,
    required this.book,
    required this.isRent,
    required this.onConfirm,
  });

  @override
  State<TransactionBottomSheet> createState() => _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends State<TransactionBottomSheet> {
  int rentalDuration = 1;
  final int baseRentalPrice = 5000;

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.isRent 
        ? rentalDuration * baseRentalPrice 
        : widget.book.price;

    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4, 
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))
            )
          ),
          const SizedBox(height: 24),

          // Judul
          Text(
            widget.isRent ? "Sewa Buku" : "Beli Buku", 
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.book.coverUrl,
                  width: 70, height: 100, fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(color: Colors.grey[200]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(widget.book.genre, style: TextStyle(color: Colors.blue[700], fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.book.author, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Durasi Sewa
          if (widget.isRent) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Durasi Sewa", style: TextStyle(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (rentalDuration > 1) setState(() => rentalDuration--);
                      },
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                    ),
                    Text("$rentalDuration Hari", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(
                      onPressed: () {
                        if (rentalDuration < 7) setState(() => rentalDuration++);
                      },
                      icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Total Harga & Tombol Konfirmasi
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Bayar", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    currencyFormatter.format(totalPrice), 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onConfirm(rentalDuration, totalPrice);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  widget.isRent ? "SEWA SEKARANG" : "BELI PERMANEN", 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}