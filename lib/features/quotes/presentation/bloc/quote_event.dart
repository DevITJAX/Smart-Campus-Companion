part of 'quote_bloc.dart';

/// Base event for quote BLoC
abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the quote of the day
class LoadQuoteRequested extends QuoteEvent {
  const LoadQuoteRequested();
}

/// Event to refresh the quote (force fetch from API)
class RefreshQuoteRequested extends QuoteEvent {
  const RefreshQuoteRequested();
}
