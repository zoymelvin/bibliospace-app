import 'package:bloc/bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AuthRepository _authRepository;

  TransactionBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(TransactionInitial()) {
    
    // Logic Beli
    on<TransactionPurchaseRequested>((event, emit) async {
      emit(TransactionLoading());
      try {
        await _authRepository.addTransaction(
          book: event.book,
          isRent: false,
          duration: 0,
          totalPayment: event.totalPayment,
        );
        emit(TransactionSuccess());
      } catch (e) {
        emit(TransactionFailure(e.toString().replaceAll("Exception: ", "")));
      }
    });

    // Logic Sewa
    on<TransactionRentRequested>((event, emit) async {
      emit(TransactionLoading());
      try {
        await _authRepository.addTransaction(
          book: event.book,
          isRent: true,
          duration: event.duration,
          totalPayment: event.totalPayment,
        );
        emit(TransactionSuccess());
      } catch (e) {
        emit(TransactionFailure(e.toString().replaceAll("Exception: ", "")));
      }
    });
  }
}