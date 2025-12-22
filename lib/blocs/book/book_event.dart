part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

// Event 1: Mengambil data buku
class FetchBooks extends BookEvent {}

class FetchNextPage extends BookEvent {}

// Event 2: fitur search buku
class SearchBooks extends BookEvent {
  final String query;
  const SearchBooks(this.query);

  @override
  List<Object> get props => [query];
}

// Event 3: fitur sorting buku
class SortBooks extends BookEvent {
  final SortType sortType; 
  const SortBooks(this.sortType);

  @override
  List<Object> get props => [sortType];
}