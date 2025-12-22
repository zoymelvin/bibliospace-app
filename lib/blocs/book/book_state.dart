part of 'book_bloc.dart';
enum BookStatus { initial, loading, success, failure }
enum SortType { newest, oldest, titleAZ, titleZA, priceLowHigh, priceHighLow }

class BookState extends Equatable {
  final BookStatus status;
  final List<BookModel> books;          
  final List<BookModel> filteredBooks;
  final String errorMessage;
  final SortType currentSort;
  final bool hasReachedMax;
  final int currentPage;

  const BookState({
    this.status = BookStatus.initial,
    this.books = const [],
    this.filteredBooks = const [],
    this.errorMessage = '',
    this.currentSort = SortType.titleAZ,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  BookState copyWith({
    BookStatus? status,
    List<BookModel>? books,
    List<BookModel>? filteredBooks,
    String? errorMessage,
    SortType? currentSort,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      errorMessage: errorMessage ?? this.errorMessage,
      currentSort: currentSort ?? this.currentSort,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [status, books, filteredBooks, errorMessage, currentSort];
}