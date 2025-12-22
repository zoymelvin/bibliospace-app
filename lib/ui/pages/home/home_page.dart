import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/book/book_bloc.dart'; 
import '../../widgets/book_card.dart';
import '../../widgets/custom_dropdown.dart';
import '../search/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _sortOptions = [
    'Terbaru', 'Terlama', 'Terendah', 'Tertinggi', 'Judul A-Z', 'Judul Z-A'
  ];
  
  String _currentSelectedSortLabel = 'Terbaru';

  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(FetchBooks());
  }

  void _handleSortChange(String label) {
    setState(() {
      _currentSelectedSortLabel = label;
    });

    SortType type;
    switch (label) {
      case 'Terbaru': type = SortType.newest; break;
      case 'Terlama': type = SortType.oldest; break;
      case 'Terendah': type = SortType.priceLowHigh; break;
      case 'Tertinggi': type = SortType.priceHighLow; break;
      case 'Judul A-Z': type = SortType.titleAZ; break;
      case 'Judul Z-A': type = SortType.titleZA; break;
      default: type = SortType.newest;
    }
    context.read<BookBloc>().add(SortBooks(type));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),
        title: const Text(
          'BiblioSpace',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          
          // 1. Loading Awal
          if (state.status == BookStatus.loading && state.filteredBooks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error Awal
          if (state.status == BookStatus.failure && state.filteredBooks.isEmpty) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          final displayBooks = state.filteredBooks;

          // 3. Kosong
          if (state.status == BookStatus.success && displayBooks.isEmpty) {
             return const Center(child: Text('Tidak ada buku ditemukan'));
          }

          // 4. Sukses dengan Data
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.7) {
                context.read<BookBloc>().add(FetchNextPage());
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                
                // HEADER 
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomDropdown(
                          value: _currentSelectedSortLabel,
                          items: _sortOptions,
                          onChanged: (val) {
                            if (val != null) _handleSortChange(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // GRID BUKU
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.60,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = displayBooks[index];
                        return BookCard(
                          book: book, 
                          //ontap
                        );
                      },
                      childCount: displayBooks.length,
                    ),
                  ),
                ),

                // LOADING 
                if (!state.hasReachedMax)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: SizedBox(
                          width: 24, height: 24, 
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),
                  
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          );
        },
      ),
    );
  }
}