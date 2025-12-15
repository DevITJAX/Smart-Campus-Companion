import 'package:equatable/equatable.dart';

/// Entity representing a scheduled class
class ScheduleClassEntity extends Equatable {
  final String id;
  final String classId;
  final String name;
  final String instructor;
  final String room;
  final String building;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String startTime;
  final String endTime;
  final String color;

  const ScheduleClassEntity({
    required this.id,
    required this.classId,
    required this.name,
    required this.instructor,
    required this.room,
    required this.building,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.color,
  });

  @override
  List<Object?> get props => [id, classId, name, instructor, room, building, dayOfWeek, startTime, endTime, color];
}
