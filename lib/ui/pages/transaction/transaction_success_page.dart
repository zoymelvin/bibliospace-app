import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../home/main_page.dart'; // Pastikan import ini mengarah ke MainPage kamu

class TransactionSuccessPage extends StatefulWidget {
  const TransactionSuccessPage({super.key});

  @override
  State<TransactionSuccessPage> createState() => _TransactionSuccessPageState();
}

class _TransactionSuccessPageState extends State<TransactionSuccessPage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(vsync: this);

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),

            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_atippmse.json', 
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
                fit: BoxFit.contain,
                repeat: false,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // JUDUL
            const Text(
              "Pembayaran Berhasil!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // SUB-JUDUL
            Text(
              "Buku telah berhasil ditambahkan.\nSelamat menikmati bacaan barumu.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            
            const Spacer(),
            
            CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              "Mengalihkan halaman...",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}