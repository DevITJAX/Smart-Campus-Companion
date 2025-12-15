import 'package:equatable/equatable.dart';

/// User roles for role-based navigation
enum UserRole {
  student,
  professor,
  admin;

  /// Parse role from string (case-insensitive)
  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'professor':
        return UserRole.professor;
      default:
        return UserRole.student;
    }
  }
}

/// User entity representing authenticated user data
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? studentId;
  final String? classId;
  final String? photoUrl;
  final DateTime? createdAt;
  final UserRole role;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.studentId,
    this.classId,
    this.photoUrl,
    this.createdAt,
    this.role = UserRole.student,
  });

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is professor
  bool get isProfessor => role == UserRole.professor;

  /// Check if user is student
  bool get isStudent => role == UserRole.student;

  @override
  List<Object?> get props => [uid, email, displayName, studentId, classId, photoUrl, createdAt, role];

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? studentId,
    String? classId,
    String? photoUrl,
    DateTime? createdAt,
    UserRole? role,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
    );
  }
}
