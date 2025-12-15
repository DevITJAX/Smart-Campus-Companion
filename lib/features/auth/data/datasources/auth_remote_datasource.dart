import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<UserModel> signIn({required String email, required String password});

  /// Sign up with email, password, and user info
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
    String? studentId,
  });

  /// Sign out current user
  Future<void> signOut();

  /// Get current user
  Future<UserModel?> getCurrentUser();

  /// Stream of auth state changes
  Stream<UserModel?> get authStateChanges;
}

/// Implementation of AuthRemoteDataSource using Firebase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Sign in failed');
      }

      return await _getUserModel(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
    String? studentId,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Sign up failed');
      }

      // Update display name
      await credential.user!.updateDisplayName(displayName);

      // Create user document in Firestore
      final userModel = UserModel(
        uid: credential.user!.uid,
        email: email,
        displayName: displayName,
        studentId: studentId,
        createdAt: DateTime.now(),
      );

      await firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .set(userModel.toFirestore());

      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;
      return await _getUserModel(user);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getUserModel(user);
    });
  }

  /// Helper to get UserModel from Firebase User
  Future<UserModel> _getUserModel(firebase_auth.User user) async {
    final doc = await firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    return UserModel.fromFirebase(
      uid: user.uid,
      email: user.email ?? '',
      firestoreData: doc.data(),
    );
  }

  /// Map Firebase auth exceptions to our custom exceptions
  AuthException _mapFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const AuthException(message: 'Invalid email address', code: 1);
      case 'wrong-password':
        return const AuthException(message: 'Wrong password', code: 2);
      case 'user-not-found':
        return const AuthException(message: 'User not found', code: 3);
      case 'email-already-in-use':
        return const AuthException(message: 'Email already in use', code: 4);
      case 'weak-password':
        return const AuthException(message: 'Password is too weak', code: 5);
      case 'user-disabled':
        return const AuthException(message: 'User account is disabled', code: 6);
      default:
        return AuthException(message: e.message ?? 'Authentication error', code: -1);
    }
  }
}
