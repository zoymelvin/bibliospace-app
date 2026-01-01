import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/book/book_bloc.dart';
import '../../widgets/book_card.dart';
import '../detail/book_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Cari judul, penulis, atau genre...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {}); 
              context.read<BookBloc>().add(SearchBooks(value));
            },
          ),
        ),
      ),

      body: isSearching 
          ? _buildSearchResults()
          : _buildEmptyState(),  
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.manage_search_rounded, 
            size: 100, 
            color: Colors.grey.shade300
          ),
          const SizedBox(height: 20),
          Text(
            "Mau baca buku apa hari ini?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ketik judul buku untuk mulai mencari",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state.status == BookStatus.loading) {
           return const Center(child: CircularProgressIndicator());
        }
        
        if (state.filteredBooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  "Buku tidak ditemukan",
                  style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        // Tampilkan Grid Buku
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.60,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.filteredBooks.length,
          itemBuilder: (context, index) {
            final book = state.filteredBooks[index];
            return BookCard(
              book: book,
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (c) => BookDetailPage(book: book))
                );
              },
            );
          },
        );
      },
    );
  }
}