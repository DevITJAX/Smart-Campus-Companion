// ignore_for_file: avoid_print
/// Script to seed test users into Firebase Auth
/// 
/// Run with: flutter run -t lib/scripts/seed_users.dart
/// 
/// This script creates multiple test users for demonstration/testing purposes.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

/// List of test users to create
final List<Map<String, String>> testUsers = [
  {
    'email': 'student1@campus.edu',
    'password': 'Student123!',
    'name': 'Alice Johnson',
    'role': 'student',
  },
  {
    'email': 'student2@campus.edu',
    'password': 'Student123!',
    'name': 'Bob Smith',
    'role': 'student',
  },
  {
    'email': 'student3@campus.edu',
    'password': 'Student123!',
    'name': 'Charlie Brown',
    'role': 'student',
  },
  {
    'email': 'professor@campus.edu',
    'password': 'Professor123!',
    'name': 'Dr. Emily Davis',
    'role': 'professor',
  },
  {
    'email': 'admin@campus.edu',
    'password': 'Admin123!',
    'name': 'System Admin',
    'role': 'admin',
  },
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🚀 Starting user seeding...\n');

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  int created = 0;
  int skipped = 0;
  int failed = 0;

  for (final user in testUsers) {
    try {
      print('Creating user: ${user['email']}...');
      
      // Create user in Firebase Auth
      final credential = await auth.createUserWithEmailAndPassword(
        email: user['email']!,
        password: user['password']!,
      );

      // Update display name
      await credential.user?.updateDisplayName(user['name']);

      // Store additional user data in Firestore
      await firestore.collection('users').doc(credential.user!.uid).set({
        'email': user['email'],
        'name': user['name'],
        'role': user['role'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('  ✅ Created: ${user['name']} (${user['email']})\n');
      created++;
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('  ⏭️  Skipped: ${user['email']} (already exists)\n');
        skipped++;
      } else {
        print('  ❌ Failed: ${user['email']} - ${e.message}\n');
        failed++;
      }
    } catch (e) {
      print('  ❌ Failed: ${user['email']} - $e\n');
      failed++;
    }
  }

  // Sign out after creating users
  await auth.signOut();

  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📊 Summary:');
  print('   Created: $created');
  print('   Skipped: $skipped');
  print('   Failed:  $failed');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('\n✨ User seeding complete!');
  print('\nTest accounts:');
  for (final user in testUsers) {
    print('  📧 ${user['email']} / ${user['password']}');
  }
}
