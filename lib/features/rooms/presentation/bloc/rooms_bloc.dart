import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/building_entity.dart';
import '../../domain/entities/room_entity.dart';
import '../../data/repositories/rooms_repository_impl.dart';

// Events
abstract class RoomsEvent extends Equatable {
  const RoomsEvent();
  @override
  List<Object?> get props => [];
}

class RoomsLoadRequested extends RoomsEvent {}

class RoomsRefreshRequested extends RoomsEvent {}

class RoomsBuildingFilterChanged extends RoomsEvent {
  final String? buildingId;
  const RoomsBuildingFilterChanged(this.buildingId);
  @override
  List<Object?> get props => [buildingId];
}

// States
abstract class RoomsState extends Equatable {
  const RoomsState();
  @override
  List<Object?> get props => [];
}

class RoomsInitial extends RoomsState {}

class RoomsLoading extends RoomsState {}

class RoomsLoaded extends RoomsState {
  final List<RoomEntity> allRooms;
  final List<RoomEntity> filteredRooms;
  final List<BuildingEntity> buildings;
  final String? selectedBuildingId;

  const RoomsLoaded({
    required this.allRooms,
    required this.filteredRooms,
    required this.buildings,
    this.selectedBuildingId,
  });

  @override
  List<Object?> get props => [allRooms, filteredRooms, buildings, selectedBuildingId];

  RoomsLoaded copyWith({
    List<RoomEntity>? allRooms,
    List<RoomEntity>? filteredRooms,
    List<BuildingEntity>? buildings,
    String? selectedBuildingId,
  }) {
    return RoomsLoaded(
      allRooms: allRooms ?? this.allRooms,
      filteredRooms: filteredRooms ?? this.filteredRooms,
      buildings: buildings ?? this.buildings,
      selectedBuildingId: selectedBuildingId ?? this.selectedBuildingId,
    );
  }
}

class RoomsError extends RoomsState {
  final String message;

  const RoomsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final RoomsRepository repository;

  RoomsBloc({required this.repository}) : super(RoomsInitial()) {
    on<RoomsLoadRequested>(_onLoadRequested);
    on<RoomsRefreshRequested>(_onRefreshRequested);
    on<RoomsBuildingFilterChanged>(_onBuildingFilterChanged);
  }

  Future<void> _onLoadRequested(
    RoomsLoadRequested event,
    Emitter<RoomsState> emit,
  ) async {
    emit(RoomsLoading());
    
    final buildingsResult = await repository.getBuildings();
    final roomsResult = await repository.getRooms();

    if (buildingsResult.isLeft() || roomsResult.isLeft()) {
      emit(const RoomsError(message: 'Failed to load rooms data'));
      return;
    }

    final buildings = buildingsResult.getOrElse(() => []);
    final rooms = roomsResult.getOrElse(() => []);

    emit(RoomsLoaded(
      allRooms: rooms,
      filteredRooms: rooms,
      buildings: buildings,
    ));
  }

  Future<void> _onRefreshRequested(
    RoomsRefreshRequested event,
    Emitter<RoomsState> emit,
  ) async {
    final roomsResult = await repository.getRooms();
    
    roomsResult.fold(
      (failure) => emit(RoomsError(message: failure.message)),
      (rooms) {
        if (state is RoomsLoaded) {
          final currentState = state as RoomsLoaded;
          List<RoomEntity> filtered = rooms;
          if (currentState.selectedBuildingId != null) {
            filtered = rooms.where((r) => r.buildingId == currentState.selectedBuildingId).toList();
          }
          emit(currentState.copyWith(
            allRooms: rooms,
            filteredRooms: filtered,
          ));
        }
      },
    );
  }

  void _onBuildingFilterChanged(
    RoomsBuildingFilterChanged event,
    Emitter<RoomsState> emit,
  ) {
    if (state is RoomsLoaded) {
      final currentState = state as RoomsLoaded;
      List<RoomEntity> filtered;
      
      if (event.buildingId == null) {
        filtered = currentState.allRooms;
      } else {
        filtered = currentState.allRooms.where((r) => r.buildingId == event.buildingId).toList();
      }

      emit(RoomsLoaded(
        allRooms: currentState.allRooms,
        filteredRooms: filtered,
        buildings: currentState.buildings,
        selectedBuildingId: event.buildingId,
      ));
    }
  }
}
