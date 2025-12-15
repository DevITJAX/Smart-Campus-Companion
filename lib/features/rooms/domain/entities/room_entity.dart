import 'package:equatable/equatable.dart';

/// Entity representing a campus room
class RoomEntity extends Equatable {
  final String id;
  final String name;
  final String buildingId;
  final String buildingName;
  final int floor;
  final int capacity;
  final bool isAvailable;
  final String? currentEvent;
  final String? type;
  final List<String>? amenities;

  const RoomEntity({
    required this.id,
    required this.name,
    required this.buildingId,
    required this.buildingName,
    required this.floor,
    required this.capacity,
    this.isAvailable = true,
    this.currentEvent,
    this.type,
    this.amenities,
  });

  @override
  List<Object?> get props => [id, name, buildingId, buildingName, floor, capacity, isAvailable, currentEvent, type, amenities];
}
