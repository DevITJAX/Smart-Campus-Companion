import 'package:equatable/equatable.dart';

/// Entity representing a campus service
class ServiceEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final String iconName;
  final String hours;
  final String location;
  final String? phone;
  final String? email;
  final bool isActive;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.iconName,
    required this.hours,
    required this.location,
    this.phone,
    this.email,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, description, category, iconName, hours, location, phone, email, isActive];
}
