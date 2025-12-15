import '../../domain/entities/building_entity.dart';

/// Building model for Firebase data mapping
class BuildingModel extends BuildingEntity {
  const BuildingModel({
    required super.id,
    required super.name,
    required super.code,
    super.description,
    required super.floors,
    super.address,
    super.latitude,
    super.longitude,
  });

  /// Create BuildingModel from Firestore document
  factory BuildingModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return BuildingModel(
      id: docId,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      description: json['description'] as String?,
      floors: json['floors'] as int? ?? 1,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'code': code,
      'description': description,
      'floors': floors,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
