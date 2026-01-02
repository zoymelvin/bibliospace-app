import 'change_name_page.dart';
import 'change_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../pages/auth/login_page.dart';
import '../../widgets/profile_header_card.dart'; 
import '../../widgets/profile_menu_tile.dart';          

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const Scaffold(body: Center(child: Text("Guest")));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ProfileHeaderCard(user: user),

            const SizedBox(height: 30),
            
            const Text(
              "Pengaturan Akun",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ProfileMenuTile(
              title: "Ganti Nama",
              icon: Icons.person_outline,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const ChangeNamePage()));
              },
            ),
            ProfileMenuTile(
              title: "Ganti Password",
              icon: Icons.lock_outline,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const ChangePasswordPage()));
              },
            ),

            const ProfileMenuTile(
              title: "Tentang Aplikasi",
              icon: Icons.info_outline,
              onTap: null,
              trailingText: "v1.0.2",
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.red.shade200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  foregroundColor: Colors.red.shade50,
                ),
                icon: Icon(Icons.logout, color: Colors.red.shade700),
                label: Text(
                  "Keluar Aplikasi",
                  style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}