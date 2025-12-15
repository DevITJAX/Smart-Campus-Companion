part of 'quote_bloc.dart';

/// Base state for quote BLoC
abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class QuoteInitial extends QuoteState {}

/// Loading state
class QuoteLoading extends QuoteState {}

/// Loaded state with quote data
class QuoteLoaded extends QuoteState {
  final QuoteEntity quote;

  const QuoteLoaded({required this.quote});

  @override
  List<Object?> get props => [quote];
}

/// Error state
class QuoteError extends QuoteState {
  final String message;

  const QuoteError({required this.message});

  @override
  List<Object?> get props => [message];
}
