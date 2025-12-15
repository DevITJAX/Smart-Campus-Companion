import '../../domain/entities/room_entity.dart';

/// Room model for Firebase data mapping
class RoomModel extends RoomEntity {
  const RoomModel({
    required super.id,
    required super.name,
    required super.buildingId,
    required super.buildingName,
    required super.floor,
    required super.capacity,
    super.isAvailable,
    super.currentEvent,
    super.type,
    super.amenities,
  });

  /// Create RoomModel from Firestore document
  factory RoomModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return RoomModel(
      id: docId,
      name: json['name'] as String? ?? '',
      buildingId: json['buildingId'] as String? ?? '',
      buildingName: json['buildingName'] as String? ?? '',
      floor: json['floor'] as int? ?? 1,
      capacity: json['capacity'] as int? ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      currentEvent: json['currentEvent'] as String?,
      type: json['type'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'buildingId': buildingId,
      'buildingName': buildingName,
      'floor': floor,
      'capacity': capacity,
      'isAvailable': isAvailable,
      'currentEvent': currentEvent,
      'type': type,
      'amenities': amenities,
    };
  }
}
