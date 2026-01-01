import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math'; 
import '../../data/models/book_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get user => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<QuerySnapshot> getUserTransactionsStream() {
    final uid = currentUser?.uid;
    if (uid == null) return const Stream.empty();
    
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getBookTransactionsStream(String bookTitle) {
    final uid = currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .where('book_title', isEqualTo: bookTitle)
        .snapshots();
  }

  Future<void> addTransaction({
    required BookModel book,
    required bool isRent,
    required int duration,
    required int totalPayment,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) throw Exception("User tidak login");

    final String transactionId = "TXN-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}";
    final String createdAt = DateTime.now().toIso8601String();

    // Data Transaksi
    Map<String, dynamic> transactionData = {
      'book_id': book.id,
      'book_title': book.title,
      'book_author': book.author,
      'book_cover': book.coverUrl,
      'book_genre': book.genre,
      'book_price': book.price,
      'transaction_id': transactionId,
      'total_payment': totalPayment,
      'created_at': createdAt,
      'type': isRent ? 'rent' : 'purchase',
    };

    if (isRent) {
      final String returnDate = DateTime.now().add(Duration(days: duration)).toIso8601String();
      transactionData['rental_duration'] = duration;
      transactionData['return_date'] = returnDate;
    }

    // Simpan Transaksi
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .add(transactionData);

    //  Buat Notifikasi
    String notifTitle = isRent ? "Sewa Berhasil" : "Pembelian Berhasil";
    String notifBody = isRent 
        ? "Buku \"${book.title}\" berhasil disewa selama $duration hari."
        : "Buku \"${book.title}\" kini menjadi milikmu permanen.";

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .add({
      'title': notifTitle,
      'body': notifBody,
      'type': 'info',
      'is_read': false,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<User?> signUp({required String email, required String password, required String name}) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await result.user?.updateDisplayName(name);
      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'uid': result.user!.uid,
          'name': name,
          'email': email,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> checkAndNotifyExpiredRentals() async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final now = DateTime.now();
    final userRef = _firestore.collection('users').doc(uid);
    final snapshot = await userRef.collection('transactions')
        .where('type', isEqualTo: 'rent')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      if (data['return_date'] == null) continue;

      final returnDate = DateTime.parse(data['return_date']);

      bool isNotified = data['expiry_notified'] ?? false;

      if (returnDate.isBefore(now) && !isNotified) {

        String fullTitle = data['book_title'] ?? 'Buku';
        String displayTitle = fullTitle;

        if (fullTitle.length > 20) {
          displayTitle = "${fullTitle.substring(0, 20)}...";
        }
        displayTitle = displayTitle.toUpperCase();

        await userRef.collection('notifications').add({
          'title': "Masa Sewa Habis",
          'body': "Masa sewa \"$displayTitle\" berakhir. Sewa lagi jika ingin lanjut.", 
          'type': 'alert', 
          'is_read': false,
          'created_at': FieldValue.serverTimestamp(),
          'book_id': data['book_id'], 
        });

        await doc.reference.update({'expiry_notified': true});
      }
    }
  }

  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}