import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/products_repository.dart';
import '../../domain/product.dart';

/// Outcome of resolving a scanned barcode.
sealed class BarcodeScanState {
  const BarcodeScanState();
}

/// Camera is live, nothing detected yet.
class BarcodeScanning extends BarcodeScanState {
  const BarcodeScanning();
}

class BarcodeLookingUp extends BarcodeScanState {
  const BarcodeLookingUp(this.code);

  final String code;
}

class BarcodeFound extends BarcodeScanState {
  const BarcodeFound(this.product);

  final BarcodeProduct product;
}

/// The code scanned cleanly but no source recognises it — the UI offers the
/// OCR label scan instead. This is an expected outcome, not a failure.
class BarcodeNotFound extends BarcodeScanState {
  const BarcodeNotFound(this.code);

  final String code;
}

class BarcodeLookupFailed extends BarcodeScanState {
  const BarcodeLookupFailed(this.message);

  final String message;
}

/// Resolves scanned barcodes against the backend, which proxies to the web
/// API that owns the catalogue. Detection itself lives in the view, since it
/// is driven by the camera stream.
class BarcodeScanViewModel extends Notifier<BarcodeScanState> {
  String? _inFlight;

  @override
  BarcodeScanState build() => const BarcodeScanning();

  /// Ignores repeat detections of the same code — the camera stream fires
  /// continuously while a barcode stays in frame.
  Future<void> lookup(String code) async {
    if (_inFlight == code) return;
    if (state is BarcodeFound || state is BarcodeLookingUp) return;
    _inFlight = code;
    state = BarcodeLookingUp(code);

    final next = await _resolve(code);
    _inFlight = null;
    // This provider is autoDispose and the user can leave the scanner while
    // a lookup is in flight; writing state after that throws.
    if (!ref.mounted) return;
    state = next;
  }

  Future<BarcodeScanState> _resolve(String code) async {
    final repository = ref.read(productsRepositoryProvider);
    try {
      return BarcodeFound(await repository.findByBarcode(code));
    } on NotFoundException {
      return BarcodeNotFound(code);
    } on AppException catch (error) {
      return BarcodeLookupFailed(error.message);
    } catch (_) {
      return const BarcodeLookupFailed(
        'Could not look up that barcode. Please try again.',
      );
    }
  }

  /// Returns to live scanning, e.g. after dismissing the not-found sheet.
  void reset() {
    _inFlight = null;
    state = const BarcodeScanning();
  }
}

final barcodeScanViewModelProvider =
    NotifierProvider.autoDispose<BarcodeScanViewModel, BarcodeScanState>(
  BarcodeScanViewModel.new,
);
