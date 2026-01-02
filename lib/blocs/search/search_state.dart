import 'package:equatable/equatable.dart';
import '../../data/models/book_model.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<BookModel> books;
  final String errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.books = const [],
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [status, books, errorMessage];
}