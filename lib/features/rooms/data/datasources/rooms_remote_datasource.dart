import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/building_model.dart';
import '../models/room_model.dart';

/// Remote data source for rooms and buildings from Firebase
abstract class RoomsRemoteDataSource {
  Future<List<BuildingModel>> getBuildings();
  Future<List<RoomModel>> getRooms();
  Future<List<RoomModel>> getRoomsByBuilding(String buildingId);
  Stream<List<RoomModel>> watchRooms();
}

class RoomsRemoteDataSourceImpl implements RoomsRemoteDataSource {
  final FirebaseFirestore firestore;

  RoomsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<BuildingModel>> getBuildings() async {
    try {
      final snapshot = await firestore
          .collection('buildings')
          .get();

      final buildings = snapshot.docs
          .map((doc) => BuildingModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Sort by name in memory
      buildings.sort((a, b) => a.name.compareTo(b.name));

      return buildings;
    } catch (e) {
      debugPrint('Error fetching buildings: $e');
      return [];
    }
  }

  @override
  Future<List<RoomModel>> getRooms() async {
    try {
      final snapshot = await firestore
          .collection('rooms')
          .get();

      final rooms = snapshot.docs
          .map((doc) => RoomModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Sort by building name then room name in memory
      rooms.sort((a, b) {
        final buildingCompare = a.buildingName.compareTo(b.buildingName);
        if (buildingCompare != 0) return buildingCompare;
        return a.name.compareTo(b.name);
      });

      return rooms;
    } catch (e) {
      debugPrint('Error fetching rooms: $e');
      return [];
    }
  }

  @override
  Future<List<RoomModel>> getRoomsByBuilding(String buildingId) async {
    try {
      final snapshot = await firestore
          .collection('rooms')
          .where('buildingId', isEqualTo: buildingId)
          .get();

      final rooms = snapshot.docs
          .map((doc) => RoomModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Sort by name in memory
      rooms.sort((a, b) => a.name.compareTo(b.name));

      return rooms;
    } catch (e) {
      debugPrint('Error fetching rooms by building: $e');
      return [];
    }
  }

  @override
  Stream<List<RoomModel>> watchRooms() {
    return firestore
        .collection('rooms')
        .snapshots()
        .map((snapshot) {
          final rooms = snapshot.docs
              .map((doc) => RoomModel.fromFirestore(doc.data(), doc.id))
              .toList();

          // Sort by building name then room name in memory
          rooms.sort((a, b) {
            final buildingCompare = a.buildingName.compareTo(b.buildingName);
            if (buildingCompare != 0) return buildingCompare;
            return a.name.compareTo(b.name);
          });

          return rooms;
        });
  }
}
