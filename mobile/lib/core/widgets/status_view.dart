import 'package:flutter/material.dart';

import '../error/app_exception.dart';
import '../theme/app_spacing.dart';
import 'gradient_button.dart';

/// Shared empty/error/offline state with an optional retry action.
class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Try Again',
  });

  const StatusView.error({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.onRetry,
    this.retryLabel = 'Try Again',
  }) : icon = Icons.error_outline_rounded;

  const StatusView.empty({
    super.key,
    this.title = 'Nothing here yet',
    required this.message,
    this.onRetry,
    this.retryLabel = 'Refresh',
  }) : icon = Icons.inbox_outlined;

  const StatusView.offline({
    super.key,
    this.title = 'You are offline',
    this.message = 'Check your connection and try again.',
    this.onRetry,
    this.retryLabel = 'Retry',
  }) : icon = Icons.wifi_off_rounded;

  /// Maps a repository failure to the right state: a dropped connection or
  /// timeout reads as "offline" rather than a generic error, and typed
  /// [AppException]s surface their own message instead of [fallbackMessage].
  factory StatusView.forError(
    Object? error, {
    required String fallbackMessage,
    VoidCallback? onRetry,
  }) {
    if (error is NetworkException || error is TimeoutException) {
      return StatusView.offline(
        message: (error as AppException).message,
        onRetry: onRetry,
      );
    }
    return StatusView.error(
      message: error is AppException ? error.message : fallbackMessage,
      onRetry: onRetry,
    );
  }

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(message,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: 200,
                child: GradientButton(label: retryLabel, onPressed: onRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
