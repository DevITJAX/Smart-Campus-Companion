import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/service_entity.dart';
import '../../data/repositories/services_repository_impl.dart';

// Events
abstract class ServicesEvent extends Equatable {
  const ServicesEvent();
  @override
  List<Object?> get props => [];
}

class ServicesLoadRequested extends ServicesEvent {}

class ServicesRefreshRequested extends ServicesEvent {}

// States
abstract class ServicesState extends Equatable {
  const ServicesState();
  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceEntity> services;
  final Set<String> favoriteIds;

  const ServicesLoaded({
    required this.services,
    this.favoriteIds = const {},
  });

  @override
  List<Object?> get props => [services, favoriteIds];

  ServicesLoaded copyWith({
    List<ServiceEntity>? services,
    Set<String>? favoriteIds,
  }) {
    return ServicesLoaded(
      services: services ?? this.services,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository repository;

  ServicesBloc({required this.repository}) : super(ServicesInitial()) {
    on<ServicesLoadRequested>(_onLoadRequested);
    on<ServicesRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    ServicesLoadRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    final result = await repository.getServices();
    result.fold(
      (failure) => emit(ServicesError(message: failure.message)),
      (services) => emit(ServicesLoaded(services: services)),
    );
  }

  Future<void> _onRefreshRequested(
    ServicesRefreshRequested event,
    Emitter<ServicesState> emit,
  ) async {
    final result = await repository.getServices();
    result.fold(
      (failure) => emit(ServicesError(message: failure.message)),
      (services) {
        final currentFavorites = state is ServicesLoaded
            ? (state as ServicesLoaded).favoriteIds
            : <String>{};
        emit(ServicesLoaded(services: services, favoriteIds: currentFavorites));
      },
    );
  }
}
