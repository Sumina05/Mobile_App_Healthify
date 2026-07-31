import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../viewmodels/auth_form_viewmodels.dart';
import '../widgets/auth_scaffold.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key, required this.email, this.devCode});

  /// Email carried over from the forgot-password step.
  final String email;

  /// Reset code surfaced by non-production backends for testing.
  final String? devCode;

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.email);
  late final _code = TextEditingController(text: widget.devCode ?? '');
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(resetPasswordViewModelProvider.notifier).submit(
          email: _email.text.trim(),
          code: _code.text.trim(),
          newPassword: _password.text,
        );
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated — log in with your new password'),
        ),
      );
      context.go(RoutePaths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetPasswordViewModelProvider);
    ref.listen(resetPasswordViewModelProvider, (_, next) {
      if (next.hasError && !next.isLoading) {
        showErrorSnackBar(context, next.error!);
      }
    });

    return AuthScaffold(
      title: 'Reset Password',
      subtitle: 'Enter the 6-digit code and choose a new password.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Email',
                controller: _email,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.base),
              AppTextField(
                label: 'Reset Code',
                controller: _code,
                hint: '6-digit code',
                prefixIcon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().length != 6)
                    ? 'Enter the 6-digit code'
                    : null,
              ),
              const SizedBox(height: AppSpacing.base),
              AppTextField(
                label: 'New Password',
                controller: _password,
                hint: 'Min. 8 characters, letters & numbers',
                prefixIcon: Icons.lock_outline_rounded,
                obscure: true,
                validator: Validators.password,
              ),
              const SizedBox(height: AppSpacing.base),
              AppTextField(
                label: 'Confirm New Password',
                controller: _confirm,
                prefixIcon: Icons.lock_outline_rounded,
                obscure: true,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    Validators.confirmPassword(v, _password.text),
              ),
              const SizedBox(height: AppSpacing.lg),
              GradientButton(
                label: 'Update Password',
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
