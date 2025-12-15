import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/service_entity.dart';
import '../bloc/services_bloc.dart';

/// Services page showing campus services from Firebase
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ServicesBloc>()..add(ServicesLoadRequested()),
      child: const _ServicesPageContent(),
    );
  }
}

class _ServicesPageContent extends StatefulWidget {
  const _ServicesPageContent();

  @override
  State<_ServicesPageContent> createState() => _ServicesPageContentState();
}

class _ServicesPageContentState extends State<_ServicesPageContent> {
  final Set<String> _favorites = {};

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic':
        return AppTheme.primaryColor;
      case 'Technical':
        return AppTheme.accentColor;
      case 'Dining':
        return AppTheme.warningColor;
      case 'Health':
        return AppTheme.errorColor;
      case 'Recreation':
        return AppTheme.successColor;
      case 'Career':
        return AppTheme.secondaryColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'local_library':
        return Icons.local_library;
      case 'computer':
        return Icons.computer;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'assignment_ind':
        return Icons.assignment_ind;
      case 'print':
        return Icons.print;
      case 'work':
        return Icons.work;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ServicesBloc>().add(ServicesRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<ServicesBloc, ServicesState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return const LoadingWidget(message: 'Loading services...');
          }

          if (state is ServicesError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () => context.read<ServicesBloc>().add(ServicesLoadRequested()),
            );
          }

          if (state is ServicesLoaded) {
            final services = state.services;

            if (services.isEmpty) {
              return const EmptyStateWidget(
                title: 'No Services',
                subtitle: 'Campus services will appear here',
                icon: Icons.business,
              );
            }

            return CustomScrollView(
              slivers: [
                // Favorites section
                if (_favorites.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        '⭐ Favorites',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _favorites.length,
                        itemBuilder: (context, index) {
                          final service = services.firstWhere(
                            (s) => s.id == _favorites.elementAt(index),
                            orElse: () => services.first,
                          );
                          return _FavoriteServiceCard(
                            name: service.name,
                            icon: _getIconFromName(service.iconName),
                            color: _getCategoryColor(service.category),
                            onTap: () => _showServiceDetails(context, service),
                          );
                        },
                      ),
                    ),
                  ),
                ],
                // All services
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'All Services',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final service = services[index];
                        return _ServiceCard(
                          id: service.id,
                          name: service.name,
                          description: service.description,
                          category: service.category,
                          icon: _getIconFromName(service.iconName),
                          hours: service.hours,
                          color: _getCategoryColor(service.category),
                          isFavorite: _favorites.contains(service.id),
                          onFavoriteToggle: () => _toggleFavorite(service.id),
                          onTap: () => _showServiceDetails(context, service),
                        );
                      },
                      childCount: services.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showServiceDetails(BuildContext context, ServiceEntity service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
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
                      color: _getCategoryColor(service.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getIconFromName(service.iconName),
                      color: _getCategoryColor(service.category),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          service.category,
                          style: TextStyle(
                            color: _getCategoryColor(service.category),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                service.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _DetailRow(icon: Icons.access_time, label: 'Hours', value: service.hours),
              _DetailRow(icon: Icons.location_on, label: 'Location', value: service.location),
              if (service.phone != null)
                _DetailRow(icon: Icons.phone, label: 'Phone', value: service.phone!),
              if (service.email != null)
                _DetailRow(icon: Icons.email, label: 'Email', value: service.email!),
            ],
          ),
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

class _FavoriteServiceCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FavoriteServiceCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final String hours;
  final Color color;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.hours,
    required this.color,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? AppTheme.warningColor : Colors.grey,
                    ),
                    onPressed: onFavoriteToggle,
                    iconSize: 22,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    hours,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
