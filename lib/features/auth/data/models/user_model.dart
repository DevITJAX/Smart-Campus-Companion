import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

/// User model for Firebase data mapping
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.studentId,
    super.classId,
    super.photoUrl,
    super.createdAt,
    super.role,
  });

  /// Create UserModel from Firebase User and Firestore document
  factory UserModel.fromFirebase({
    required String uid,
    required String email,
    Map<String, dynamic>? firestoreData,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: firestoreData?['displayName'] as String? ?? 
                   firestoreData?['name'] as String?,
      studentId: firestoreData?['studentId'] as String?,
      classId: firestoreData?['classId'] as String?,
      photoUrl: firestoreData?['photoUrl'] as String?,
      createdAt: firestoreData?['createdAt'] != null
          ? (firestoreData!['createdAt'] as Timestamp).toDate()
          : null,
      // Parse role from Firestore - defaults to student if not found
      role: UserRole.fromString(firestoreData?['role'] as String?),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'studentId': studentId,
      'classId': classId,
      'photoUrl': photoUrl,
      'role': role.name,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  /// Convert UserEntity to UserModel
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      studentId: entity.studentId,
      classId: entity.classId,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
      role: entity.role,
    );
  }
}
