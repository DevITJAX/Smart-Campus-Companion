import '../../domain/entities/schedule_class_entity.dart';

/// Schedule class model for Firebase data mapping
class ScheduleClassModel extends ScheduleClassEntity {
  const ScheduleClassModel({
    required super.id,
    required super.classId,
    required super.name,
    required super.instructor,
    required super.room,
    required super.building,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    required super.color,
  });

  /// Create ScheduleClassModel from Firestore document
  factory ScheduleClassModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return ScheduleClassModel(
      id: docId,
      classId: json['classId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      room: json['room'] as String? ?? '',
      building: json['building'] as String? ?? '',
      dayOfWeek: json['dayOfWeek'] as int? ?? 1,
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      color: json['color'] as String? ?? '#4CAF50',
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'classId': classId,
      'name': name,
      'instructor': instructor,
      'room': room,
      'building': building,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
    };
  }
}
