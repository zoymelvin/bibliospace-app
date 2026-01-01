import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AuthRepository _authRepository;

  FavoriteBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(FavoriteInitial()) {
    
    on<AddToFavorite>((event, emit) async {
      try {
        await _authRepository.addFavorite(event.book);
        emit(const FavoriteSuccess("Ditambahkan ke Favorit"));
      } catch (e) {
        emit(FavoriteFailure(e.toString()));
      }
    });

    on<RemoveFromFavorite>((event, emit) async {
      try {
        await _authRepository.removeFavorite(event.title); 
        emit(const FavoriteSuccess("Dihapus dari Favorit"));
      } catch (e) {
        emit(FavoriteFailure(e.toString()));
      }
    });
  }
}