import 'package:equatable/equatable.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}
final class FavoriteLoading extends FavoriteState {}
final class FavoriteSuccess extends FavoriteState {
  final String message;
  const FavoriteSuccess(this.message);
}
final class FavoriteFailure extends FavoriteState {
  final String error;
  const FavoriteFailure(this.error);
}