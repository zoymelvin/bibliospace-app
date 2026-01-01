import 'package:equatable/equatable.dart';
import '../../data/models/book_model.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object> get props => [];
}

class AddToFavorite extends FavoriteEvent {
  final BookModel book;
  const AddToFavorite(this.book);
}

class RemoveFromFavorite extends FavoriteEvent {
  final String title;
  const RemoveFromFavorite(this.title);
  
  @override
  List<Object> get props => [title];
}