import 'package:equatable/equatable.dart';
import '../../data/models/book_model.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransactionPurchaseRequested extends TransactionEvent {
  final BookModel book;
  final int totalPayment;

  const TransactionPurchaseRequested({
    required this.book,
    required this.totalPayment,
  });

  @override
  List<Object> get props => [book, totalPayment];
}

class TransactionRentRequested extends TransactionEvent {
  final BookModel book;
  final int duration;
  final int totalPayment;

  const TransactionRentRequested({
    required this.book,
    required this.duration,
    required this.totalPayment,
  });

  @override
  List<Object> get props => [book, duration, totalPayment];
}