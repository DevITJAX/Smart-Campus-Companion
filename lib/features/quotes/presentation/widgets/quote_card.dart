import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/quote_bloc.dart';

/// Widget displaying the quote of the day
class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  @override
  void initState() {
    super.initState();
    context.read<QuoteBloc>().add(const LoadQuoteRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppTheme.primaryColor.withValues(alpha: 0.3),
                      AppTheme.secondaryColor.withValues(alpha: 0.2),
                    ]
                  : [
                      AppTheme.primaryColor.withValues(alpha: 0.15),
                      AppTheme.secondaryColor.withValues(alpha: 0.1),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<QuoteBloc>().add(const RefreshQuoteRequested());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildContent(context, state),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, QuoteState state) {
    if (state is QuoteLoading) {
      return const _QuoteLoadingContent();
    } else if (state is QuoteLoaded) {
      return _QuoteLoadedContent(
        content: state.quote.content,
        author: state.quote.author,
      );
    } else if (state is QuoteError) {
      return _QuoteErrorContent(
        message: state.message,
        onRetry: () {
          context.read<QuoteBloc>().add(const LoadQuoteRequested());
        },
      );
    } else {
      return const _QuotePlaceholderContent();
    }
  }
}

class _QuoteLoadingContent extends StatelessWidget {
  const _QuoteLoadingContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.format_quote,
          size: 32,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.primaryColor.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Loading today\'s inspiration...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }
}

class _QuoteLoadedContent extends StatelessWidget {
  final String content;
  final String author;

  const _QuoteLoadedContent({
    required this.content,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.format_quote,
              size: 28,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Quote of the Day',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.refresh,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '"$content"',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '— $author',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryColor,
                ),
          ),
        ),
      ],
    );
  }
}

class _QuoteErrorContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _QuoteErrorContent({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.format_quote,
          size: 32,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 12),
        Text(
          'Could not load quote',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Tap to retry'),
        ),
      ],
    );
  }
}

class _QuotePlaceholderContent extends StatelessWidget {
  const _QuotePlaceholderContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.format_quote,
          size: 32,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 12),
        Text(
          'Tap to load today\'s quote',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }
}
