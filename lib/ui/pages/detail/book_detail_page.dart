import 'package:flutter/material.dart';
import '../../../data/models/book_model.dart';
import 'book_detail_widgets.dart'; 

class BookDetailPage extends StatefulWidget {
  final BookModel book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool isWatchlist = false;

  void _toggleWatchlist() {
    setState(() {
      isWatchlist = !isWatchlist;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isWatchlist ? "Disimpan ke Watchlist" : "Dihapus dari Watchlist"),
        duration: const Duration(milliseconds: 800),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Detail Buku", 
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),

      bottomNavigationBar: BookBottomBar(
        price: widget.book.price,
        onRent: () {}, 
        onBuy: () {},  
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30), 

            BookCoverSection(
              coverUrl: widget.book.coverUrl, 
              title: widget.book.title
            ),

            const SizedBox(height: 30), 

            Divider(color: Colors.grey[100], thickness: 8),

            const SizedBox(height: 20),

           Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  BookInfoSection(
                    book: widget.book,
                    isWatchlist: isWatchlist,
                    onWatchlistTap: _toggleWatchlist,
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
    );
  }
}