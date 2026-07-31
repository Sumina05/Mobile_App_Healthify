import 'package:flutter/material.dart';

/// Brand loading indicator; [AppLoader.fullscreen] centers it in a page.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 32});

  final double size;

  static Widget fullscreen() => const Center(child: AppLoader());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
