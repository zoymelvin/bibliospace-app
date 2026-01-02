import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/search/search_bloc.dart';
import '../../../blocs/search/search_event.dart';
import '../../../blocs/search/search_state.dart';
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.read<SearchBloc>().add(const SearchQueryChanged(''));
            Navigator.pop(context);
          },
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
              context.read<SearchBloc>().add(SearchQueryChanged(value));
            },
          ),
        ),
      ),

      body: _searchController.text.isEmpty 
          ? _buildEmptyState() 
          : _buildSearchResults(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.manage_search_rounded, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            "Mau baca buku apa hari ini?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
            "Ketik judul buku untuk mulai mencari",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.status == SearchStatus.loading) {
           return const Center(child: CircularProgressIndicator());
        }
        
        if (state.status == SearchStatus.failure) {
           return Center(child: Text("Error: ${state.errorMessage}"));
        }
        
        if (state.status == SearchStatus.success && state.books.isEmpty) {
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

        if (state.status == SearchStatus.initial) {
           return const SizedBox.shrink(); 
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.60,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.books.length,
          itemBuilder: (context, index) {
            final book = state.books[index];
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