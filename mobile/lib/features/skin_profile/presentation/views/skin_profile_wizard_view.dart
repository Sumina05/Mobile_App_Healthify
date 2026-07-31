import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/skin_profile_viewmodel.dart';

const _skinTypes = [
  ('oily', 'Oily'),
  ('dry', 'Dry'),
  ('combination', 'Combination'),
  ('sensitive', 'Sensitive'),
  ('normal', 'Normal'),
];

const _concerns = [
  ('acne', 'Acne'),
  ('dark_spots', 'Dark Spots'),
  ('dullness', 'Dullness'),
  ('redness', 'Redness'),
  ('aging', 'Aging'),
  ('oiliness', 'Oiliness'),
  ('dryness', 'Dryness'),
  ('texture', 'Texture'),
  ('pores', 'Pores'),
];

const _goals = [
  'Clearer skin',
  'Even skin tone',
  'Deep hydration',
  'Anti-aging',
  'Calmer, less red skin',
  'Simple reliable routine',
];

const _genders = [
  ('female', 'Female'),
  ('male', 'Male'),
  ('other', 'Other'),
  ('prefer_not_to_say', 'Prefer not to say'),
];

class SkinProfileWizardView extends ConsumerWidget {
  const SkinProfileWizardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final form = ref.watch(skinProfileViewModelProvider);
    final vm = ref.read(skinProfileViewModelProvider.notifier);
    final isLast = form.step == SkinProfileViewModel.totalSteps - 1;

    Future<void> advance() async {
      if (!vm.canAdvance) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your skin type')),
        );
        return;
      }
      if (!isLast) {
        vm.nextStep();
        return;
      }
      try {
        final user = await vm.submit();
        if (user != null && context.mounted) {
          ref.invalidate(dashboardViewModelProvider);
          context.go(RoutePaths.dashboard);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not save profile: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Skin Profile'),
        leading: form.step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: vm.previousStep,
              )
            : (context.canPop()
                ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: context.pop,
                  )
                : null),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Step ${form.step + 1} of ${SkinProfileViewModel.totalSteps}',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0,
                  end: (form.step + 1) / SkinProfileViewModel.totalSteps,
                ),
                duration: AppDurations.normal,
                builder: (context, value, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(value: value, minHeight: 6),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppDurations.normal,
                  child: switch (form.step) {
                    0 => _BasicsStep(key: const ValueKey(0), form: form),
                    1 => _SkinTypeStep(key: const ValueKey(1), form: form),
                    2 => _ConcernsStep(key: const ValueKey(2), form: form),
                    _ => _GoalsStep(key: const ValueKey(3), form: form),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
                child: GradientButton(
                  label: isLast ? 'Save Profile' : 'Next',
                  isLoading: form.submitting,
                  onPressed: advance,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepShell extends StatelessWidget {
  const _StepShell({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        ...children,
      ],
    );
  }
}

class _BasicsStep extends ConsumerWidget {
  const _BasicsStep({super.key, required this.form});

  final SkinProfileForm form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(skinProfileViewModelProvider.notifier);
    return _StepShell(
      title: 'About you',
      subtitle: 'Optional — helps us fine-tune recommendations.',
      children: [
        Text('Age', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: form.age?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'e.g. 24'),
          onChanged: (v) => vm.setAge(int.tryParse(v)),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Gender', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _genders
              .map(
                (g) => ChoiceChip(
                  label: Text(g.$2),
                  selected: form.gender == g.$1,
                  onSelected: (_) =>
                      vm.setGender(form.gender == g.$1 ? null : g.$1),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SkinTypeStep extends ConsumerWidget {
  const _SkinTypeStep({super.key, required this.form});

  final SkinProfileForm form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(skinProfileViewModelProvider.notifier);
    return _StepShell(
      title: 'Skin Type',
      subtitle: 'How does your skin usually feel by midday?',
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _skinTypes
              .map(
                (t) => ChoiceChip(
                  label: Text(t.$2),
                  selected: form.skinType == t.$1,
                  onSelected: (_) => vm.setSkinType(t.$1),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ConcernsStep extends ConsumerWidget {
  const _ConcernsStep({super.key, required this.form});

  final SkinProfileForm form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(skinProfileViewModelProvider.notifier);
    final allergyController = TextEditingController();
    return _StepShell(
      title: 'Skin Concerns',
      subtitle: 'Select all that apply — and any known allergies.',
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _concerns
              .map(
                (c) => FilterChip(
                  label: Text(c.$2),
                  selected: form.concerns.contains(c.$1),
                  onSelected: (_) => vm.toggleConcern(c.$1),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Allergies', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: allergyController,
          decoration: const InputDecoration(
            hintText: 'e.g. Fragrance — press enter to add',
          ),
          onSubmitted: (v) {
            vm.addAllergy(v);
            allergyController.clear();
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: form.allergies
              .map(
                (a) => InputChip(
                  label: Text(a),
                  onDeleted: () => vm.removeAllergy(a),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _GoalsStep extends ConsumerWidget {
  const _GoalsStep({super.key, required this.form});

  final SkinProfileForm form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(skinProfileViewModelProvider.notifier);
    return _StepShell(
      title: 'Routine Goals',
      subtitle: 'What do you want Healthify to help you achieve?',
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _goals
              .map(
                (g) => FilterChip(
                  label: Text(g),
                  selected: form.goals.contains(g),
                  onSelected: (_) => vm.toggleGoal(g),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
