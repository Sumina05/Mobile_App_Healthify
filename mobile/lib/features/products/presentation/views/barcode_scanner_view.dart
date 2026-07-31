import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../viewmodels/barcode_scan_viewmodel.dart';
import '../widgets/product_detail_sheet.dart';

/// Barcode scanner. A detected EAN/UPC is resolved by the backend against the
/// shared product catalogue; a hit opens the standard product sheet (and from
/// there the normal analysis pipeline), a miss offers the OCR label scan.
class BarcodeScannerView extends ConsumerStatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  ConsumerState<BarcodeScannerView> createState() =>
      _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends ConsumerState<BarcodeScannerView>
    with WidgetsBindingObserver {
  /// The same format set the web scanner accepts (see
  /// `Healthify_Web_Frontend/src/lib/barcode.ts`). Restricting this to the
  /// retail formats turns a readable CODE_128 into a silent "no barcode
  /// found", which is a worse outcome than reading it and reporting that the
  /// catalogue has no match.
  final BarcodeScanner _scanner = BarcodeScanner(
    formats: [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upca,
      BarcodeFormat.upce,
      BarcodeFormat.itf,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.codabar,
    ],
  );

  CameraController? _controller;
  bool _cameraFailed = false;
  bool _torchOn = false;
  bool _detecting = false;
  bool _streaming = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _scanner.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      if (mounted) {
        setState(() {
          _controller = null;
          _streaming = false;
        });
      }
      controller.dispose();
    } else if (state == AppLifecycleState.resumed && _controller == null) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    if (_cameraFailed && mounted) setState(() => _cameraFailed = false);
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
        // ML Kit wants NV21 on Android and BGRA on iOS. Read the platform
        // rather than the BuildContext — this runs after an await.
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.android
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
      await _startStream(controller);
    } catch (_) {
      if (mounted) setState(() => _cameraFailed = true);
    }
  }

  Future<void> _startStream(CameraController controller) async {
    if (_streaming) return;
    _streaming = true;
    await controller.startImageStream(_onFrame);
  }

  Future<void> _onFrame(CameraImage image) async {
    // Frames arrive faster than ML Kit can process them; drop the overlap.
    if (_detecting) return;
    final state = ref.read(barcodeScanViewModelProvider);
    if (state is! BarcodeScanning) return;
    _detecting = true;
    try {
      final input = _toInputImage(image);
      if (input == null) return;
      final barcodes = await _scanner.processImage(input);
      final value = barcodes
          .map((b) => b.rawValue)
          .firstWhere((v) => v != null && v.trim().isNotEmpty, orElse: () => null);
      if (value == null || !mounted) return;
      await HapticFeedback.mediumImpact();
      await ref
          .read(barcodeScanViewModelProvider.notifier)
          .lookup(value.trim());
    } catch (_) {
      // A frame that fails to decode is normal; the next one will retry.
    } finally {
      _detecting = false;
    }
  }

  InputImage? _toInputImage(CameraImage image) {
    final controller = _controller;
    if (controller == null || image.planes.isEmpty) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw as int);
    if (format == null) return null;

    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotationValue.fromRawValue(
              controller.description.sensorOrientation,
            ) ??
            InputImageRotation.rotation0deg,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final next = !_torchOn;
    try {
      await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      setState(() => _torchOn = next);
    } catch (_) {
      // Emulators and some devices have no torch.
    }
  }

  void _openOcrScanner() {
    ref.read(barcodeScanViewModelProvider.notifier).reset();
    context.pushReplacement(RoutePaths.scanner);
  }

  void _handleState(BarcodeScanState state) {
    if (state is BarcodeFound) {
      showProductDetailFromBarcode(context, state.product);
      // Re-arm once the sheet closes so the next product can be scanned.
      ref.read(barcodeScanViewModelProvider.notifier).reset();
    } else if (state is BarcodeNotFound) {
      _showNotFound(state.code);
    } else if (state is BarcodeLookupFailed) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
      ref.read(barcodeScanViewModelProvider.notifier).reset();
    }
  }

  Future<void> _showNotFound(String code) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ProductNotFoundSheet(
        code: code,
        onScanLabel: _openOcrScanner,
      ),
    );
    if (mounted) ref.read(barcodeScanViewModelProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = _controller;
    final ready = controller != null && controller.value.isInitialized;
    final state = ref.watch(barcodeScanViewModelProvider);

    ref.listen(barcodeScanViewModelProvider, (_, next) => _handleState(next));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (ready)
            Center(child: CameraPreview(controller))
          else if (_cameraFailed)
            _CameraUnavailable(onScanLabel: _openOcrScanner)
          else
            const Center(child: AppLoader()),
          if (ready) const _BarcodeFrame(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _RoundIconButton(
                        icon: Icons.close_rounded,
                        label: 'Close barcode scanner',
                        onTap: () => context.pop(),
                      ),
                      Text(
                        'Scan Barcode',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      _RoundIconButton(
                        icon: _torchOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        label: _torchOn ? 'Turn off torch' : 'Turn on torch',
                        onTap: _toggleTorch,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (state is BarcodeLookingUp)
                  const _StatusPill(text: 'Looking up product…', busy: true)
                else if (ready)
                  const _StatusPill(text: 'Point the camera at the barcode'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.base,
                    AppSpacing.screen,
                    AppSpacing.xl,
                  ),
                  child: TextButton.icon(
                    onPressed: _openOcrScanner,
                    icon: const Icon(Icons.document_scanner_outlined,
                        color: Colors.white),
                    label: const Text(
                      'No barcode? Scan the ingredient list',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when the scanned code is in neither the catalogue nor Open Facts.
class _ProductNotFoundSheet extends StatelessWidget {
  const _ProductNotFoundSheet({required this.code, required this.onScanLabel});

  final String code;
  final VoidCallback onScanLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.base,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
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
            child: Icon(
              Icons.search_off_rounded,
              size: 34,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Product not found',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'We could not match barcode $code to a product yet. You can still '
            'get a full analysis by scanning the ingredient list on the pack.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          GradientButton(
            label: 'Scan Ingredient List',
            icon: Icons.document_scanner_outlined,
            onPressed: () {
              Navigator.of(context).pop();
              onScanLabel();
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Scan another barcode'),
          ),
        ],
      ),
    );
  }
}

class _CameraUnavailable extends StatelessWidget {
  const _CameraUnavailable({required this.onScanLabel});

  final VoidCallback onScanLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_outlined,
                size: 48, color: Colors.white70),
            const SizedBox(height: AppSpacing.base),
            Text(
              'Camera unavailable',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Check camera permissions, or analyze the product by scanning '
              'its ingredient list instead.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            GradientButton(
              label: 'Scan Ingredient List',
              icon: Icons.document_scanner_outlined,
              onPressed: onScanLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, this.busy = false});

  final String text;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (busy) ...[
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.mint,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            text,
            style: theme.textTheme.labelMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Wide, short reticle — barcodes are scanned landscape.
class _BarcodeFrame extends StatelessWidget {
  const _BarcodeFrame();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 280,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mint, width: 3),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    required this.label,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String label;

  static const double size = 44;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: size * 0.5),
          ),
        ),
      ),
    );
  }
}
