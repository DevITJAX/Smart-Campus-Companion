import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/announcement_entity.dart';
import '../../domain/usecases/get_announcements_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC for home page with announcements
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;

  HomeBloc({required this.getAnnouncementsUseCase}) : super(HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    await _loadAnnouncements(emit);
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    await _loadAnnouncements(emit);
  }

  Future<void> _loadAnnouncements(Emitter<HomeState> emit) async {
    final result = await getAnnouncementsUseCase();
    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (announcements) => emit(HomeLoaded(announcements: announcements)),
    );
  }
}
