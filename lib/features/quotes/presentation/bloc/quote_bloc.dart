import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/usecases/get_quote_of_the_day_usecase.dart';

part 'quote_event.dart';
part 'quote_state.dart';

/// BLoC for managing quote of the day
class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetQuoteOfTheDayUseCase getQuoteOfTheDayUseCase;

  QuoteBloc({required this.getQuoteOfTheDayUseCase}) : super(QuoteInitial()) {
    on<LoadQuoteRequested>(_onLoadQuoteRequested);
    on<RefreshQuoteRequested>(_onRefreshQuoteRequested);
  }

  Future<void> _onLoadQuoteRequested(
    LoadQuoteRequested event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuoteLoading());
    final result = await getQuoteOfTheDayUseCase();
    result.fold(
      (failure) => emit(QuoteError(message: failure.message)),
      (quote) => emit(QuoteLoaded(quote: quote)),
    );
  }

  Future<void> _onRefreshQuoteRequested(
    RefreshQuoteRequested event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuoteLoading());
    final result = await getQuoteOfTheDayUseCase();
    result.fold(
      (failure) => emit(QuoteError(message: failure.message)),
      (quote) => emit(QuoteLoaded(quote: quote)),
    );
  }
}
