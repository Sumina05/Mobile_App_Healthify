import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../viewmodels/scanner_viewmodel.dart';
import '../widgets/scan_review_sheet.dart';

/// Live camera scanner with framing overlay, torch, and gallery fallback.
/// Captured frames run through on-device ML Kit OCR; the parsed list opens
/// in a review sheet before being sent to the analysis engine.
class ScannerView extends ConsumerStatefulWidget {
  const ScannerView({super.key});

  @override
  ConsumerState<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends ConsumerState<ScannerView>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _cameraFailed = false;
  bool _torchOn = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Reset so a retry after a failure can succeed.
    if (_cameraFailed && mounted) setState(() => _cameraFailed = false);
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
      );
      setState(() {
        _controller = controller;
        _initFuture = controller.initialize().then((_) {
          if (mounted) setState(() {});
        });
      });
      await _initFuture;
    } catch (_) {
      if (mounted) setState(() => _cameraFailed = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      // Clear the reference *before* disposing, and rebuild — otherwise the
      // tree keeps rendering a CameraPreview backed by a disposed controller.
      if (mounted) {
        setState(() {
          _controller = null;
          _initFuture = null;
        });
      } else {
        _controller = null;
        _initFuture = null;
      }
      controller.dispose();
    } else if (state == AppLifecycleState.resumed && _controller == null) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _afterOcr() async {
    final state = ref.read(scannerViewModelProvider);
    if (!mounted) return;

    // The ViewModel wraps OCR in AsyncValue.guard, so failures land in the
    // state rather than being thrown — without this the user taps the
    // shutter and nothing at all happens.
    if (state.hasError) {
      final error = state.error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException
                ? error.message
                : 'Could not read that image. Try again with more light.',
          ),
        ),
      );
      return;
    }

    final result = state.value;
    if (result == null) return; // Picker dismissed.
    if (result.ingredients.isEmpty) {
      // A distinct buzz for "read the image, found nothing usable" — the user
      // is looking at the pack, not the screen. Fired without awaiting so the
      // message is not gated behind the vibration.
      unawaited(HapticFeedback.vibrate());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No ingredient list found — retake with the "Ingredients:" '
            'section clearly visible.',
          ),
        ),
      );
      return;
    }
    // Successful OCR — same confirmation the barcode scanner gives.
    unawaited(HapticFeedback.mediumImpact());
    final analysis = await showScanReviewSheet(context, result);
    if (analysis != null && mounted) {
      ref.read(scannerViewModelProvider.notifier).clear();
      context.pushReplacement('/analysis/${analysis.id}');
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (_busy || controller == null || !controller.value.isInitialized) {
      return;
    }
    setState(() => _busy = true);
    try {
      final file = await controller.takePicture();
      await ref
          .read(scannerViewModelProvider.notifier)
          .recognizeFile(file.path);
      await _afterOcr();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Capture failed — try again')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickFromGallery() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(scannerViewModelProvider.notifier)
          .scan(ImageSource.gallery);
      await _afterOcr();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the gallery — check app permissions'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final next = !_torchOn;
    try {
      await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      setState(() => _torchOn = next);
    } catch (_) {
      // Some devices (and emulators) have no torch — ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = _controller;
    final ready = controller != null && controller.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (ready)
            Center(
              child: CameraPreview(controller),
            )
          else if (_cameraFailed)
            _CameraUnavailable(onPickGallery: _pickFromGallery)
          else
            const Center(child: AppLoader()),
          if (ready) const _FrameOverlay(),
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
                        label: 'Close scanner',
                        onTap: () => context.pop(),
                      ),
                      Text(
                        'Scan Ingredient List',
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
                if (ready)
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      'Position the ingredient list within the frame',
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _RoundIconButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Choose a photo from the gallery',
                        size: 52,
                        onTap: _pickFromGallery,
                      ),
                      Semantics(
                        button: true,
                        enabled: ready && !_busy,
                        label: _busy
                            ? 'Reading the label'
                            : 'Capture ingredient list',
                        onTap: ready && !_busy ? _capture : null,
                        excludeSemantics: true,
                        child: GestureDetector(
                          onTap: ready ? _capture : null,
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: AppColors.mint, width: 4),
                            ),
                            child: _busy
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: AppColors.mint,
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: AppColors.mint,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 52, height: 52),
                    ],
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

class _FrameOverlay extends StatelessWidget {
  const _FrameOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.82,
          height: MediaQuery.of(context).size.height * 0.42,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.mint.withValues(alpha: 0.9),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                spreadRadius: 900,
              ),
            ],
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
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback onTap;

  /// The scanner is an icon-only surface, so every control needs a name for
  /// screen readers and a tooltip on long-press.
  final String label;
  final double size;

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

class _CameraUnavailable extends StatelessWidget {
  const _CameraUnavailable({required this.onPickGallery});

  final VoidCallback onPickGallery;

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
                size: 56, color: AppColors.darkTextSecondary),
            const SizedBox(height: AppSpacing.base),
            Text(
              'Camera unavailable',
              style:
                  theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Grant camera permission or pick an image from your gallery.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.darkTextSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onPickGallery,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Choose from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
