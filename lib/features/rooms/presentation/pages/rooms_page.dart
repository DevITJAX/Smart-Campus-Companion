import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/room_entity.dart';
import '../bloc/rooms_bloc.dart';

/// Rooms page showing available campus rooms from Firebase
class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<RoomsBloc>()..add(RoomsLoadRequested()),
      child: const _RoomsPageContent(),
    );
  }
}

class _RoomsPageContent extends StatelessWidget {
  const _RoomsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Availability'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<RoomsBloc>().add(RoomsRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<RoomsBloc, RoomsState>(
        builder: (context, state) {
          if (state is RoomsLoading) {
            return const LoadingWidget(message: 'Loading rooms...');
          }

          if (state is RoomsError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () => context.read<RoomsBloc>().add(RoomsLoadRequested()),
            );
          }

          if (state is RoomsLoaded) {
            return _RoomsLoadedContent(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _RoomsLoadedContent extends StatelessWidget {
  final RoomsLoaded state;

  const _RoomsLoadedContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final filteredRooms = state.filteredRooms;
    final buildings = state.buildings;

    return Column(
      children: [
        // Building filter
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: buildings.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                final isSelected = state.selectedBuildingId == null;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: isSelected,
                    onSelected: (selected) {
                      context.read<RoomsBloc>().add(const RoomsBuildingFilterChanged(null));
                    },
                    selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.primaryColor,
                  ),
                );
              }

              final building = buildings[index - 1];
              final isSelected = building.id == state.selectedBuildingId;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(building.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    context.read<RoomsBloc>().add(
                      RoomsBuildingFilterChanged(selected ? building.id : null),
                    );
                  },
                  selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryColor,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Stats row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _StatCard(
                label: 'Available',
                count: filteredRooms.where((r) => r.isAvailable).length,
                color: AppTheme.successColor,
                icon: Icons.check_circle,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'Occupied',
                count: filteredRooms.where((r) => !r.isAvailable).length,
                color: AppTheme.errorColor,
                icon: Icons.cancel,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Room list
        Expanded(
          child: filteredRooms.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Rooms',
                  subtitle: 'No rooms found for this filter',
                  icon: Icons.meeting_room_outlined,
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredRooms.length,
                  itemBuilder: (context, index) {
                    final room = filteredRooms[index];
                    return _RoomCard(room: room);
                  },
                ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final RoomEntity room;

  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: (room.isAvailable ? AppTheme.successColor : AppTheme.errorColor)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.meeting_room,
              color: room.isAvailable ? AppTheme.successColor : AppTheme.errorColor,
              size: 28,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              room.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (room.isAvailable ? AppTheme.successColor : AppTheme.errorColor)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                room.isAvailable ? 'Available' : 'Occupied',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: room.isAvailable ? AppTheme.successColor : AppTheme.errorColor,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${room.buildingName} • Floor ${room.floor} • Capacity: ${room.capacity}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            if (room.type != null) ...[
              const SizedBox(height: 2),
              Text(
                room.type!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
            if (room.currentEvent != null) ...[
              const SizedBox(height: 4),
              Text(
                '📍 ${room.currentEvent}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () => _showRoomDetails(context, room),
        ),
      ),
    );
  }

  void _showRoomDetails(BuildContext context, RoomEntity room) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (room.isAvailable ? AppTheme.successColor : AppTheme.errorColor)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.meeting_room,
                    color: room.isAvailable ? AppTheme.successColor : AppTheme.errorColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        room.isAvailable ? 'Available' : 'Occupied',
                        style: TextStyle(
                          color: room.isAvailable ? AppTheme.successColor : AppTheme.errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailRow(icon: Icons.business, label: 'Building', value: room.buildingName),
            _DetailRow(icon: Icons.layers, label: 'Floor', value: room.floor.toString()),
            _DetailRow(icon: Icons.people, label: 'Capacity', value: '${room.capacity} people'),
            if (room.type != null)
              _DetailRow(icon: Icons.category, label: 'Type', value: room.type!),
            if (room.currentEvent != null)
              _DetailRow(icon: Icons.event, label: 'Current Event', value: room.currentEvent!),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
