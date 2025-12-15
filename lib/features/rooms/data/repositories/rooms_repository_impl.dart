import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/building_entity.dart';
import '../../domain/entities/room_entity.dart';
import '../datasources/rooms_remote_datasource.dart';

/// Repository for rooms and buildings data
abstract class RoomsRepository {
  Future<Either<Failure, List<BuildingEntity>>> getBuildings();
  Future<Either<Failure, List<RoomEntity>>> getRooms();
  Future<Either<Failure, List<RoomEntity>>> getRoomsByBuilding(String buildingId);
  Stream<List<RoomEntity>> watchRooms();
}

class RoomsRepositoryImpl implements RoomsRepository {
  final RoomsRemoteDataSource remoteDataSource;

  RoomsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BuildingEntity>>> getBuildings() async {
    try {
      final buildings = await remoteDataSource.getBuildings();
      return Right(buildings);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load buildings: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RoomEntity>>> getRooms() async {
    try {
      final rooms = await remoteDataSource.getRooms();
      return Right(rooms);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load rooms: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RoomEntity>>> getRoomsByBuilding(String buildingId) async {
    try {
      final rooms = await remoteDataSource.getRoomsByBuilding(buildingId);
      return Right(rooms);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load rooms: $e'));
    }
  }

  @override
  Stream<List<RoomEntity>> watchRooms() {
    return remoteDataSource.watchRooms();
  }
}
