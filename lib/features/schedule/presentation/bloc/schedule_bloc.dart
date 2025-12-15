import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/schedule_class_entity.dart';
import '../../data/repositories/schedule_repository_impl.dart';

// Events
abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
  @override
  List<Object?> get props => [];
}

class ScheduleLoadRequested extends ScheduleEvent {
  final String classId;
  const ScheduleLoadRequested(this.classId);
  @override
  List<Object?> get props => [classId];
}

class ScheduleRefreshRequested extends ScheduleEvent {
  final String classId;
  const ScheduleRefreshRequested(this.classId);
  @override
  List<Object?> get props => [classId];
}

class ScheduleDayChanged extends ScheduleEvent {
  final int dayIndex;
  const ScheduleDayChanged(this.dayIndex);
  @override
  List<Object?> get props => [dayIndex];
}

// States
abstract class ScheduleState extends Equatable {
  const ScheduleState();
  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleClassEntity> allClasses;
  final Map<int, List<ScheduleClassEntity>> classesByDay;
  final int selectedDayIndex;

  const ScheduleLoaded({
    required this.allClasses,
    required this.classesByDay,
    required this.selectedDayIndex,
  });

  @override
  List<Object?> get props => [allClasses, classesByDay, selectedDayIndex];

  List<ScheduleClassEntity> get todayClasses => classesByDay[selectedDayIndex + 1] ?? [];

  ScheduleLoaded copyWith({
    List<ScheduleClassEntity>? allClasses,
    Map<int, List<ScheduleClassEntity>>? classesByDay,
    int? selectedDayIndex,
  }) {
    return ScheduleLoaded(
      allClasses: allClasses ?? this.allClasses,
      classesByDay: classesByDay ?? this.classesByDay,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
    );
  }
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository repository;

  ScheduleBloc({required this.repository}) : super(ScheduleInitial()) {
    on<ScheduleLoadRequested>(_onLoadRequested);
    on<ScheduleRefreshRequested>(_onRefreshRequested);
    on<ScheduleDayChanged>(_onDayChanged);
  }

  Future<void> _onLoadRequested(
    ScheduleLoadRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    final result = await repository.getScheduleByClassId(event.classId);
    
    result.fold(
      (failure) => emit(ScheduleError(message: failure.message)),
      (classes) {
        final classesByDay = _groupByDay(classes);
        emit(ScheduleLoaded(
          allClasses: classes,
          classesByDay: classesByDay,
          selectedDayIndex: DateTime.now().weekday - 1,
        ));
      },
    );
  }

  Future<void> _onRefreshRequested(
    ScheduleRefreshRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final result = await repository.getScheduleByClassId(event.classId);
    
    result.fold(
      (failure) => emit(ScheduleError(message: failure.message)),
      (classes) {
        final classesByDay = _groupByDay(classes);
        final currentDayIndex = state is ScheduleLoaded 
            ? (state as ScheduleLoaded).selectedDayIndex 
            : DateTime.now().weekday - 1;
        emit(ScheduleLoaded(
          allClasses: classes,
          classesByDay: classesByDay,
          selectedDayIndex: currentDayIndex,
        ));
      },
    );
  }

  void _onDayChanged(
    ScheduleDayChanged event,
    Emitter<ScheduleState> emit,
  ) {
    if (state is ScheduleLoaded) {
      final currentState = state as ScheduleLoaded;
      emit(currentState.copyWith(selectedDayIndex: event.dayIndex));
    }
  }

  Map<int, List<ScheduleClassEntity>> _groupByDay(List<ScheduleClassEntity> classes) {
    final map = <int, List<ScheduleClassEntity>>{};
    for (final cls in classes) {
      map.putIfAbsent(cls.dayOfWeek, () => []).add(cls);
    }
    return map;
  }
}
