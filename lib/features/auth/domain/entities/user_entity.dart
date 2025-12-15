import 'package:equatable/equatable.dart';

/// User entity representing authenticated user data
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? studentId;
  final String? classId;
  final String? photoUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.studentId,
    this.classId,
    this.photoUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, displayName, studentId, classId, photoUrl, createdAt];

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? studentId,
    String? classId,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

