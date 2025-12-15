import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/rest_announcement_entity.dart';
import '../bloc/rest_announcements_bloc.dart';
import '../../../../injection_container.dart';

/// Page displaying announcements fetched from REST API.
/// 
/// This page demonstrates:
/// - BLoC pattern for state management
/// - Material Design UI
/// - Light and dark mode support
/// - Loading, success, and error states
class RestAnnouncementsPage extends StatelessWidget {
  const RestAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create BLoC and immediately trigger load
      create: (context) => sl<RestAnnouncementsBloc>()
        ..add(LoadRestAnnouncements()),
      child: const _RestAnnouncementsView(),
    );
  }
}

class _RestAnnouncementsView extends StatelessWidget {
  const _RestAnnouncementsView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('REST Announcements'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              context.read<RestAnnouncementsBloc>().add(LoadRestAnnouncements());
            },
          ),
        ],
      ),
      body: BlocBuilder<RestAnnouncementsBloc, RestAnnouncementsState>(
        builder: (context, state) {
          // ========================================
          // LOADING STATE
          // ========================================
          if (state is RestAnnouncementsLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading announcements...'),
                ],
              ),
            );
          }

          // ========================================
          // ERROR STATE
          // ========================================
          if (state is RestAnnouncementsError) {
            return _ErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<RestAnnouncementsBloc>()
                    .add(RetryLoadRestAnnouncements());
              },
            );
          }

          // ========================================
          // LOADED STATE
          // ========================================
          if (state is RestAnnouncementsLoaded) {
            if (state.announcements.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No announcements available'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<RestAnnouncementsBloc>()
                    .add(LoadRestAnnouncements());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.announcements.length,
                itemBuilder: (context, index) {
                  return _AnnouncementCard(
                    announcement: state.announcements[index],
                  );
                },
              ),
            );
          }

          // ========================================
          // INITIAL STATE
          // ========================================
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

/// Card widget for displaying a single announcement.
class _AnnouncementCard extends StatelessWidget {
  final RestAnnouncementEntity announcement;

  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Show announcement details in a dialog
          _showAnnouncementDetails(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with ID badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${announcement.id}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: colorScheme.outline,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                _capitalizeTitle(announcement.title),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Body preview
              Text(
                announcement.body,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalizeTitle(String title) {
    if (title.isEmpty) return title;
    return title[0].toUpperCase() + title.substring(1);
  }

  void _showAnnouncementDetails(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ID and User badges
              Row(
                children: [
                  _Badge(
                    icon: Icons.tag,
                    label: 'ID: ${announcement.id}',
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  _Badge(
                    icon: Icons.person_outline,
                    label: 'User: ${announcement.userId}',
                    color: colorScheme.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                _capitalizeTitle(announcement.title),
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Divider
              Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
              const SizedBox(height: 16),

              // Body
              Text(
                announcement.body,
                style: textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge widget for metadata display.
class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error widget with retry button.
class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),

            // Error title
            Text(
              'Failed to Load',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Error message
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Retry button
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
