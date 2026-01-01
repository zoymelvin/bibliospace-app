import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math'; 

import '../../../data/models/book_model.dart';
import '../../widgets/transaction_bottom_sheet.dart'; 
import '../transaction/transaction_success_page.dart'; 
import 'book_detail_widgets.dart'; 

class BookDetailPage extends StatefulWidget {
  final BookModel book;
  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  bool isWatchlist = false;

  void _toggleWatchlist() {
    setState(() => isWatchlist = !isWatchlist);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isWatchlist ? "Disimpan ke Watchlist" : "Dihapus dari Watchlist"),
      duration: const Duration(milliseconds: 500),
    ));
  }

  Future<void> _processTransaction(bool isRent, int duration, int totalPayment) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Harap Login terlebih dahulu")));
      return;
    }
    
    showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));

    try {
      final String transactionId = "TXN-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}";
      final String createdAt = DateTime.now().toIso8601String();

      Map<String, dynamic> transactionData = {
        'book_title': widget.book.title,
        'transaction_id': transactionId,
        'total_payment': totalPayment,
        'created_at': createdAt,
        'type': isRent ? 'rent' : 'purchase', 
      };

      if (isRent) {
        final String returnDate = DateTime.now().add(Duration(days: duration)).toIso8601String();
        transactionData['rental_duration'] = duration;
        transactionData['return_date'] = returnDate;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .add(transactionData);

      if (mounted) {
        Navigator.pop(context); 
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionSuccessPage()));
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  void _showTransactionPopup({required bool isRent}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return TransactionBottomSheet(
          book: widget.book,
          isRent: isRent,
          onConfirm: (duration, price) {
            _processTransaction(isRent, duration, price);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('book_title', isEqualTo: widget.book.title)
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Detail Buku", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1.0), child: Container(color: Colors.grey[200], height: 1.0)),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: userId != null ? transactionQuery : const Stream.empty(),
        builder: (context, snapshot) {
          
          bool isPurchased = false;
          bool isRented = false;
          String rentalExpiryInfo = "";

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            for (var doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final String type = data['type'] ?? '';

              if (type == 'purchase') {
                isPurchased = true;
              } else if (type == 'rent') {
                final String returnDateStr = data['return_date'];
                final DateTime returnDate = DateTime.parse(returnDateStr);
                final DateTime now = DateTime.now();

                if (returnDate.isAfter(now)) {
                  isRented = true;
                  final Duration diff = returnDate.difference(now);
                  if (diff.inDays > 0) {
                    rentalExpiryInfo = "${diff.inDays} Hari lagi";
                  } else {
                    rentalExpiryInfo = "${diff.inHours} Jam lagi";
                  }
                }
              }
            }
          }

          final bool showBottomBar = !isPurchased && !isRented;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      BookCoverSection(coverUrl: widget.book.coverUrl, title: widget.book.title),
                      const SizedBox(height: 30),
                      Divider(color: Colors.grey[100], thickness: 8),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BookInfoSection(book: widget.book, isWatchlist: isWatchlist, onWatchlistTap: _toggleWatchlist),
                            
                            // INFO STATUS
                            if (isPurchased)
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                                child: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green, size: 24),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Buku Sudah Dibeli", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
                                          Text("Anda memiliki akses permanen ke buku ini.", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (isRented && !isPurchased)
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timer, color: Colors.orange, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Status Sewa Aktif", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
                                          Text("Sisa waktu baca: $rentalExpiryInfo", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 24),
                            BookSynopsisSection(synopsis: widget.book.synopsis),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (showBottomBar)
                 BookBottomBar(
                   price: widget.book.price, 
                   onBuy: () => _showTransactionPopup(isRent: false), 
                   onRent: () => _showTransactionPopup(isRent: true)
                 )
            ],
          );
        }
      ),
    );
  }
}