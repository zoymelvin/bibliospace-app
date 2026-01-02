import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../data/repositories/book_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

const _duration = Duration(milliseconds: 500);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BookRepository _bookRepository;

  SearchBloc({required BookRepository bookRepository})
      : _bookRepository = bookRepository,
        super(const SearchState()) {
    
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounce(_duration),
    );
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      return emit(const SearchState(status: SearchStatus.initial));
    }

    emit(const SearchState(status: SearchStatus.loading));

    try {
      final results = await _bookRepository.searchBooks(event.query); 
      
      if (results.isEmpty) {
        emit(const SearchState(status: SearchStatus.success, books: []));
      } else {
        emit(SearchState(status: SearchStatus.success, books: results));
      }
    } catch (e) {
      emit(SearchState(status: SearchStatus.failure, errorMessage: e.toString()));
    }
  }
}