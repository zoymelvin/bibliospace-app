import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/book_model.dart';
import '../../data/repositories/book_repository.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository bookRepository;

  bool isFetching = false;

  BookBloc({required this.bookRepository}) : super(const BookState()) {
    on<FetchBooks>(_onFetchBooks);
    on<SearchBooks>(_onSearchBooks);
    on<FetchNextPage>(_onFetchNextPage);
    on<SortBooks>(_onSortBooks);
  }

  // 1. Logic Load Awal
  Future<void> _onFetchBooks(FetchBooks event, Emitter<BookState> emit) async {
    emit(state.copyWith(status: BookStatus.loading));
    try {
      final books = await bookRepository.getBooks(page: 1);
      emit(state.copyWith(
        status: BookStatus.success,
        books: books,
        filteredBooks: books,
        currentPage: 1,
        hasReachedMax: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookStatus.failure, 
        errorMessage: e.toString()
      ));
    }
  }

  // 2. Logic Load More
  Future<void> _onFetchNextPage(FetchNextPage event, Emitter<BookState> emit) async {
    if (state.hasReachedMax || isFetching) return;

    isFetching = true;
    try {
      final nextPage = state.currentPage + 1;
      final newBooks = await bookRepository.getBooks(page: nextPage);

      if (newBooks.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        final allBooks = List.of(state.books)..addAll(newBooks);
        
        emit(state.copyWith(
          status: BookStatus.success,
          books: allBooks,
          filteredBooks: allBooks, 
          currentPage: nextPage,
          hasReachedMax: false,
        ));
      }
    } catch (e) {
      // Error silent
    } finally {
      isFetching = false;
    }
  }

  // 3. Logic Search
  void _onSearchBooks(SearchBooks event, Emitter<BookState> emit) {
    final query = event.query.toLowerCase();
    
    final results = state.books.where((book) {
      final titleLower = book.title.toLowerCase();
      final authorLower = book.author.toLowerCase();
      return titleLower.contains(query) || authorLower.contains(query);
    }).toList();

    emit(state.copyWith(filteredBooks: results));
  }

  // 4. Logic Sorting
  void _onSortBooks(SortBooks event, Emitter<BookState> emit) {
    List<BookModel> sortedList = List.from(state.filteredBooks);

    switch (event.sortType) {
      case SortType.titleAZ:
        sortedList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.titleZA:
        sortedList.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortType.priceLowHigh:
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceHighLow:
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.newest:
        sortedList.sort((a, b) => b.publicationYear.compareTo(a.publicationYear));
        break;
      case SortType.oldest:
        sortedList.sort((a, b) => a.publicationYear.compareTo(b.publicationYear));
        break;
    }

    emit(state.copyWith(
      filteredBooks: sortedList,
      currentSort: event.sortType,
    ));
  }
}