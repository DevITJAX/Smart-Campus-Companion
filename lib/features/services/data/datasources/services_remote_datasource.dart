import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/service_model.dart';

/// Remote data source for services from Firebase
abstract class ServicesRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Stream<List<ServiceModel>> watchServices();
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final FirebaseFirestore firestore;

  ServicesRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final snapshot = await firestore
          .collection('services')
          .get();

      final services = snapshot.docs
          .map((doc) => ServiceModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Filter active and sort by category in memory
      final activeServices = services.where((s) => s.isActive).toList();
      activeServices.sort((a, b) => a.category.compareTo(b.category));

      return activeServices;
    } catch (e) {
      debugPrint('Error fetching services: $e');
      return [];
    }
  }

  @override
  Stream<List<ServiceModel>> watchServices() {
    return firestore
        .collection('services')
        .snapshots()
        .map((snapshot) {
          final services = snapshot.docs
              .map((doc) => ServiceModel.fromFirestore(doc.data(), doc.id))
              .toList();

          // Filter active and sort by category in memory
          final activeServices = services.where((s) => s.isActive).toList();
          activeServices.sort((a, b) => a.category.compareTo(b.category));

          return activeServices;
        });
  }
}
