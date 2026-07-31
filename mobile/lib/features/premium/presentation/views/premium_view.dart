import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../auth/presentation/viewmodels/auth_controller.dart';
import '../../data/premium_repository.dart';
import '../viewmodels/premium_viewmodel.dart';

/// "Go Premium" — plan cards, feature list, and Khalti/eSewa checkout.
class PremiumView extends ConsumerStatefulWidget {
  const PremiumView({super.key});

  @override
  ConsumerState<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends ConsumerState<PremiumView> {
  String _selectedPlan = 'yearly';
  String _selectedProvider = 'khalti';

  @override
  Widget build(BuildContext context) {
    final plansState = ref.watch(plansProvider);
    final checkout = ref.watch(checkoutProvider);
    final auth = ref.watch(authControllerProvider);
    final isPremium = auth is Authenticated && auth.user.isPremium;

    ref.listen(checkoutProvider, (_, next) {
      if (next is CheckoutSuccess) {
        showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            icon: const Icon(Icons.workspace_premium_rounded,
                color: AppColors.warning, size: 44),
            title: const Text('Welcome to Premium!'),
            content: const Text(
              'Your plan is active. Enjoy unlimited scans and advanced AI analysis.',
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (context.canPop()) context.pop();
                },
                child: const Text('Let\'s go'),
              ),
            ],
          ),
        );
      } else if (next is CheckoutFailure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Go Premium')),
      body: SafeArea(
        child: switch (plansState) {
          AsyncValue(:final value?) => ListView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: AppGradients.accent,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: AppGradients.accentGlow,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded,
                        color: Colors.white, size: 36),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                Text(
                  isPremium
                      ? 'You are a Premium member 👑'
                      : 'Unlock the full power of Healthify',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                ...value.features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.mint, size: 20),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(feature,
                              style:
                                  Theme.of(context).textTheme.bodyLarge),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: value.plans
                      .map(
                        (plan) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs),
                            child: _PlanCard(
                              plan: plan,
                              selected: _selectedPlan == plan.id,
                              onTap: () =>
                                  setState(() => _selectedPlan = plan.id),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Pay with',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _ProviderChip(
                      label: 'Khalti',
                      color: const Color(0xFF5C2D91),
                      selected: _selectedProvider == 'khalti',
                      onTap: () =>
                          setState(() => _selectedProvider = 'khalti'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ProviderChip(
                      label: 'eSewa',
                      color: const Color(0xFF60BB46),
                      selected: _selectedProvider == 'esewa',
                      onTap: () =>
                          setState(() => _selectedProvider = 'esewa'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                if (checkout is CheckoutAwaitingGateway) ...[
                  Text(
                    'Complete the payment in your browser, then confirm below.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton(
                    label: "I've completed the payment",
                    icon: Icons.verified_rounded,
                    onPressed: () =>
                        ref.read(checkoutProvider.notifier).verify(),
                  ),
                ] else
                  GradientButton(
                    label: isPremium
                        ? 'Extend Premium'
                        : 'Pay Securely with ${_selectedProvider == 'khalti' ? 'Khalti' : 'eSewa'}',
                    icon: Icons.lock_rounded,
                    gradient: AppGradients.accent,
                    isLoading: checkout is CheckoutBusy,
                    onPressed: () => ref.read(checkoutProvider.notifier).pay(
                          plan: _selectedPlan,
                          provider: _selectedProvider,
                        ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '🔒 100% secure payment · cancel anytime',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          AsyncValue(:final error?, isLoading: false) => StatusView.forError(
              error,
              fallbackMessage: 'Could not load plans.',
              onRetry: () => ref.invalidate(plansProvider),
            ),
          _ => AppLoader.fullscreen(),
        },
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final PremiumPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: AppDurations.fast,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: selected ? AppColors.mint : theme.colorScheme.outline,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected ? AppGradients.primaryGlow : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            children: [
              Text(plan.label, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'रू ${plan.amountNpr}',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: AppColors.mint),
              ),
              Text(
                plan.id == 'monthly' ? 'per month' : 'per year',
                style: theme.textTheme.labelSmall,
              ),
              if (plan.savings != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    plan.savings!,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: AppColors.mint),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderChip extends StatelessWidget {
  const _ProviderChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.18)
                : theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected ? color : theme.colorScheme.outline,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet_rounded,
                  size: 18, color: color),
              const SizedBox(width: AppSpacing.sm),
              Text(label, style: theme.textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
