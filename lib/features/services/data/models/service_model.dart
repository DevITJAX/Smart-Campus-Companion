import '../../domain/entities/service_entity.dart';

/// Service model for Firebase data mapping
class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.iconName,
    required super.hours,
    required super.location,
    super.phone,
    super.email,
    super.isActive,
  });

  /// Create ServiceModel from Firestore document
  factory ServiceModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return ServiceModel(
      id: docId,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      iconName: json['iconName'] as String? ?? 'help_outline',
      hours: json['hours'] as String? ?? '',
      location: json['location'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'iconName': iconName,
      'hours': hours,
      'location': location,
      'phone': phone,
      'email': email,
      'isActive': isActive,
    };
  }
}
