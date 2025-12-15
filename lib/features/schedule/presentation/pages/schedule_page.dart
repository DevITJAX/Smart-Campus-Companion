import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../injection_container.dart' as di;
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/schedule_class_entity.dart';
import '../bloc/schedule_bloc.dart';

/// Schedule page showing weekly class schedule from Firebase
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ScheduleBloc>(),
      child: const _SchedulePageContent(),
    );
  }
}

class _SchedulePageContent extends StatefulWidget {
  const _SchedulePageContent();

  @override
  State<_SchedulePageContent> createState() => _SchedulePageContentState();
}

class _SchedulePageContentState extends State<_SchedulePageContent> {
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  void _loadSchedule() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final classId = authState.user.classId ?? 'CS101'; // Default class if not set
      context.read<ScheduleBloc>().add(ScheduleLoadRequested(classId));
    }
  }

  Color _parseColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              context.read<ScheduleBloc>().add(
                ScheduleDayChanged(DateTime.now().weekday - 1),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSchedule,
          ),
        ],
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const LoadingWidget(message: 'Loading schedule...');
          }

          if (state is ScheduleError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: _loadSchedule,
            );
          }

          if (state is ScheduleLoaded) {
            return _ScheduleLoadedContent(
              state: state,
              days: _days,
              parseColor: _parseColor,
            );
          }

          // Initial state - show empty or prompt
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading Your Schedule...',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ScheduleLoadedContent extends StatelessWidget {
  final ScheduleLoaded state;
  final List<String> days;
  final Color Function(String) parseColor;

  const _ScheduleLoadedContent({
    required this.state,
    required this.days,
    required this.parseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Day selector
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(days.length, (index) {
              final isSelected = index == state.selectedDayIndex;
              final isToday = index == DateTime.now().weekday - 1;
              return GestureDetector(
                onTap: () {
                  context.read<ScheduleBloc>().add(ScheduleDayChanged(index));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isToday && !isSelected
                        ? Border.all(color: AppTheme.primaryColor, width: 2)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        days[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateTime.now().add(Duration(days: index - (DateTime.now().weekday - 1))).day}',
                        style: TextStyle(
                          color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const Divider(height: 1),
        // Schedule list
        Expanded(
          child: state.todayClasses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.celebration,
                          size: 48,
                          color: AppTheme.successColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Classes Today!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enjoy your free day',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.todayClasses.length,
                  itemBuilder: (context, index) {
                    final classInfo = state.todayClasses[index];
                    return _ScheduleCard(
                      classInfo: classInfo,
                      color: parseColor(classInfo.color),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final ScheduleClassEntity classInfo;
  final Color color;

  const _ScheduleCard({
    required this.classInfo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classInfo.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${classInfo.startTime} - ${classInfo.endTime}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.room, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        classInfo.room,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        classInfo.instructor,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.business, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          classInfo.building,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
