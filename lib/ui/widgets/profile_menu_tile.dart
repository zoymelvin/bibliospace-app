import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap; // Nullable: Kalau null berarti info doang (Tentang App)
  final String? trailingText; // Untuk menampilkan versi

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        enabled: onTap != null,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Icon(icon, color: Colors.blue[800], size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        trailing: trailingText != null
            ? Text(trailingText!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12))
            : Icon(Icons.chevron_right, color: Colors.grey.shade400),
      ),
    );
  }
}