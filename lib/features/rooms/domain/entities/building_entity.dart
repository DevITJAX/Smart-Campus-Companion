import 'package:equatable/equatable.dart';

/// Entity representing a campus building
class BuildingEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String? description;
  final int floors;
  final String? address;
  final double? latitude;
  final double? longitude;

  const BuildingEntity({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.floors,
    this.address,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [id, name, code, description, floors, address, latitude, longitude];
}
