import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/app_exception.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/presentation/viewmodels/auth_controller.dart';
import '../../data/premium_repository.dart';

class PlansViewModel extends AsyncNotifier<PlansResponse> {
  @override
  Future<PlansResponse> build() =>
      ref.watch(premiumRepositoryProvider).getPlans();
}

final plansProvider =
    AsyncNotifierProvider<PlansViewModel, PlansResponse>(PlansViewModel.new);

sealed class CheckoutState {
  const CheckoutState();
}

class CheckoutIdle extends CheckoutState {
  const CheckoutIdle();
}

class CheckoutBusy extends CheckoutState {
  const CheckoutBusy();
}

/// Gateway flow: payment page opened, waiting for the user to pay.
class CheckoutAwaitingGateway extends CheckoutState {
  const CheckoutAwaitingGateway(this.providerRef);

  final String providerRef;
}

class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess();
}

class CheckoutFailure extends CheckoutState {
  const CheckoutFailure(this.message);

  final String message;
}

class CheckoutViewModel extends Notifier<CheckoutState> {
  @override
  CheckoutState build() => const CheckoutIdle();

  Future<void> pay({required String plan, required String provider}) async {
    state = const CheckoutBusy();
    try {
      final result = await ref
          .read(premiumRepositoryProvider)
          .checkout(plan: plan, provider: provider);

      if (result.status == 'completed') {
        await _refreshUser();
        state = const CheckoutSuccess();
        return;
      }
      if (result.paymentUrl != null) {
        // launchUrl returns false when no app can handle the URL; without
        // this check the UI would wait on a gateway that never opened.
        final opened = await launchUrl(
          Uri.parse(result.paymentUrl!),
          mode: LaunchMode.externalApplication,
        );
        if (!opened) {
          state = const CheckoutFailure(
            'Could not open the payment page. Please try again.',
          );
          return;
        }
        state = CheckoutAwaitingGateway(result.providerRef);
        return;
      }
      state = const CheckoutFailure('Payment could not be started');
    } on AppException catch (e) {
      state = CheckoutFailure(e.message);
    } catch (_) {
      state = const CheckoutFailure('Payment failed. Please try again.');
    }
  }

  /// Called after the user returns from the gateway ("I've completed payment").
  Future<void> verify() async {
    final current = state;
    if (current is! CheckoutAwaitingGateway) return;
    state = const CheckoutBusy();
    try {
      await ref
          .read(premiumRepositoryProvider)
          .verify(current.providerRef);
      await _refreshUser();
      state = const CheckoutSuccess();
    } on AppException catch (e) {
      state = CheckoutFailure(e.message);
    } catch (_) {
      state = const CheckoutFailure('Payment failed. Please try again.');
    }
  }

  void reset() => state = const CheckoutIdle();

  Future<void> _refreshUser() async {
    final user =
        await ref.read(authRepositoryProvider).getCurrentUser();
    ref.read(authControllerProvider.notifier).updateUser(user);
  }
}

final checkoutProvider =
    NotifierProvider.autoDispose<CheckoutViewModel, CheckoutState>(
  CheckoutViewModel.new,
);
