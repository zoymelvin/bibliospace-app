import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/favorite/favorite_bloc.dart';
import '../../../blocs/favorite/favorite_event.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../widgets/favorite_book_card.dart';
import '../../../data/models/book_model.dart';
import '../detail/book_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteStream = context.read<AuthRepository>().getFavoritesStream();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Favorit Saya", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoriteStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return FavoriteBookCard(
                data: data,
                onTap: () {
                  final book = BookModel(
                    id: data['book_id'] ?? '',
                    title: data['title'] ?? '',
                    author: data['author'] ?? '',
                    synopsis: data['synopsis'] ?? '',
                    coverUrl: data['cover_url'] ?? '',
                    publicationYear: 0,
                    genre: data['genre'] ?? 'Umum',
                    price: data['price'] ?? 0,
                  );

                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (c) => BookDetailPage(book: book))
                  );
                },
                onDelete: () {
                  final String bookTitle = data['title'] ?? '';
                 context.read<FavoriteBloc>().add(RemoveFromFavorite(bookTitle));
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Dihapus dari favorit"), duration: Duration(seconds: 1)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Belum ada buku favorit.",
            style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Simpan buku yang kamu suka di sini.",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }
}