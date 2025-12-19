import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BiblioSpace", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search, color: Colors.white)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_rounded, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 20),
            const Text("Selamat Datang di BiblioSpace!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Katalog buku akan muncul di sini.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}