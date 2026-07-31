import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

part 'scanner_viewmodel.freezed.dart';

@freezed
abstract class ScanResult with _$ScanResult {
  const factory ScanResult({
    required String rawText,
    required List<String> ingredients,
  }) = _ScanResult;
}

/// On-device OCR: capture or pick an image, extract text with ML Kit and
/// parse the ingredient list. The AI analysis pipeline (backend) consumes
/// this output in Phase 4.
class ScannerViewModel extends AsyncNotifier<ScanResult?> {
  @override
  Future<ScanResult?> build() async => null;

  Future<void> scan(ImageSource source) async {
    final previous = state.value;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final file = await ImagePicker().pickImage(
        source: source,
        imageQuality: 92,
      );
      if (file == null) return previous; // User cancelled the picker.
      return _recognize(file.path);
    });
  }

  /// OCR for an already-captured frame (live camera shutter).
  Future<void> recognizeFile(String path) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _recognize(path));
  }

  Future<ScanResult> _recognize(String path) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognized =
          await recognizer.processImage(InputImage.fromFilePath(path));
      return ScanResult(
        rawText: recognized.text,
        ingredients: parseIngredients(recognized.text),
      );
    } finally {
      await recognizer.close();
    }
  }

  void clear() => state = const AsyncData(null);

  /// Extracts individual ingredient names from OCR text: finds the
  /// "Ingredients:" marker when present, then splits on separators.
  static List<String> parseIngredients(String text) {
    var body = text.replaceAll('\n', ' ');
    final marker = RegExp('ingredients?\\s*[:：]', caseSensitive: false)
        .firstMatch(body);
    if (marker != null) {
      body = body.substring(marker.end);
    }

    return body
        .split(RegExp(r'[,;•·|]'))
        .map((token) => token.trim().replaceAll(RegExp(r'\.$'), ''))
        .where((token) => token.length >= 3 && token.length <= 60)
        .where((token) => RegExp(r'[A-Za-z]').hasMatch(token))
        .toList();
  }
}

final scannerViewModelProvider =
    AsyncNotifierProvider<ScannerViewModel, ScanResult?>(ScannerViewModel.new);
