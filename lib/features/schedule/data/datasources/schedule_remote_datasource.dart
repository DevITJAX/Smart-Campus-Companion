import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/schedule_class_model.dart';

/// Remote data source for schedule from Firebase
abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleClassModel>> getScheduleByClassId(String classId);
  Stream<List<ScheduleClassModel>> watchScheduleByClassId(String classId);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final FirebaseFirestore firestore;

  ScheduleRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ScheduleClassModel>> getScheduleByClassId(String classId) async {
    try {
      // Simple query without composite index requirement
      final snapshot = await firestore
          .collection('classes')
          .where('classId', isEqualTo: classId)
          .get();

      final classes = snapshot.docs
          .map((doc) => ScheduleClassModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Sort in memory after fetching
      classes.sort((a, b) {
        final dayCompare = a.dayOfWeek.compareTo(b.dayOfWeek);
        if (dayCompare != 0) return dayCompare;
        return a.startTime.compareTo(b.startTime);
      });

      return classes;
    } catch (e) {
      debugPrint('Error fetching schedule: $e');
      return [];
    }
  }

  @override
  Stream<List<ScheduleClassModel>> watchScheduleByClassId(String classId) {
    return firestore
        .collection('classes')
        .where('classId', isEqualTo: classId)
        .snapshots()
        .map((snapshot) {
          final classes = snapshot.docs
              .map((doc) => ScheduleClassModel.fromFirestore(doc.data(), doc.id))
              .toList();

          // Sort in memory after fetching
          classes.sort((a, b) {
            final dayCompare = a.dayOfWeek.compareTo(b.dayOfWeek);
            if (dayCompare != 0) return dayCompare;
            return a.startTime.compareTo(b.startTime);
          });

          return classes;
        });
  }
}
