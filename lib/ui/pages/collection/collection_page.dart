import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/transaction/transaction_bloc.dart';
import '../../../blocs/transaction/transaction_event.dart';
import '../../../blocs/transaction/transaction_state.dart';
import '../../../data/models/book_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../widgets/collection_book_card.dart';
import '../../widgets/transaction_bottom_sheet.dart';
import '../transaction/transaction_success_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Logic Sewa Lagi
  void _rentAgain(Map<String, dynamic> data) {
    final book = BookModel(
      id: data['book_id'] ?? '0', 
      title: data['book_title'] ?? '',
      author: data['book_author'] ?? '',
      synopsis: '...',
      coverUrl: data['book_cover'] ?? '',
      publicationYear: 0,
      genre: data['book_genre'] ?? 'Umum',
      price: data['book_price'] ?? 0,
    );

    // Buka Bottom Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionBottomSheet(
        book: book,
        isRent: true,
        onConfirm: (duration, price) async {
          Navigator.pop(context);
          context.read<TransactionBloc>().add(
            TransactionRentRequested(
              book: book,
              duration: duration,
              totalPayment: price,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoading) {
           showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));
        } else if (state is TransactionSuccess) {
           Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionSuccessPage()));
        } else if (state is TransactionFailure) {
           Navigator.pop(context);
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: ${state.error}")));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("Koleksi Saya", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.blue[900],
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue[900],
            tabs: const [
              Tab(text: "Rak Buku (Aktif)"),
              Tab(text: "Riwayat"),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: context.read<AuthRepository>().getUserTransactionsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Belum ada koleksi buku."));
            }

            final allDocs = snapshot.data!.docs;
            final now = DateTime.now();

            List<DocumentSnapshot> activeList = [];
            List<DocumentSnapshot> historyList = [];

            for (var doc in allDocs) {
              final data = doc.data() as Map<String, dynamic>;
              final type = data['type'];
              
              if (type == 'purchase') {
                activeList.add(doc);
              } else if (type == 'rent') {
                final returnDate = DateTime.parse(data['return_date']);
                if (returnDate.isAfter(now)) {
                  activeList.add(doc);
                } else {
                  historyList.add(doc);
                }
              }
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildList(activeList, isHistory: false),
                _buildList(historyList, isHistory: true),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<DocumentSnapshot> docs, {required bool isHistory}) {
    if (docs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              isHistory ? "Belum ada riwayat." : "Rak buku kosong.",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        
        return CollectionBookCard(
          data: data,
          isExpired: isHistory,
          onRentAgain: isHistory ? () => _rentAgain(data) : null,
        );
      },
    );
  }
}