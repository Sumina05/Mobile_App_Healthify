import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthify_mobile/core/error/app_exception.dart';
import 'package:healthify_mobile/core/theme/app_theme.dart';
import 'package:healthify_mobile/core/widgets/gradient_button.dart';
import 'package:healthify_mobile/core/widgets/score_ring.dart';
import 'package:healthify_mobile/core/widgets/status_view.dart';

Widget harness(Widget child) => MaterialApp(
      theme: AppTheme.dark(),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('GradientButton', () {
    testWidgets('fires onPressed when enabled', (tester) async {
      var pressed = false;
      await tester.pumpWidget(harness(
        GradientButton(label: 'Scan', onPressed: () => pressed = true),
      ));
      await tester.tap(find.text('Scan'));
      expect(pressed, isTrue);
    });

    testWidgets('shows a spinner and blocks taps while loading',
        (tester) async {
      var pressed = false;
      await tester.pumpWidget(harness(
        GradientButton(
          label: 'Scan',
          isLoading: true,
          onPressed: () => pressed = true,
        ),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Scan'), findsNothing);
      await tester.tap(find.byType(GradientButton));
      expect(pressed, isFalse);
    });
  });

  group('accessibility', () {
    testWidgets('GradientButton exposes an enabled button to screen readers',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(harness(
        GradientButton(label: 'Analyze with AI', onPressed: () {}),
      ));

      expect(
        tester.getSemantics(find.byType(GradientButton)),
        matchesSemantics(
          label: 'Analyze with AI',
          isButton: true,
          isEnabled: true,
          hasEnabledState: true,
          hasTapAction: true,
          isFocusable: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('GradientButton stays labelled while loading', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(harness(
        GradientButton(
          label: 'Analyze with AI',
          isLoading: true,
          onPressed: () {},
        ),
      ));

      // The visible label is replaced by a spinner, so the semantic label
      // must carry both the action and its in-progress state — and the
      // button must report itself as disabled with no tap action.
      expect(
        tester.getSemantics(find.byType(GradientButton)),
        matchesSemantics(
          label: 'Analyze with AI, in progress',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('ScoreRing announces one score, not two loose numbers',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(harness(const ScoreRing(score: 82)));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Score 82 out of 100'), findsOneWidget);
      // The raw "82" and "/100" text nodes must not leak through.
      expect(find.bySemanticsLabel('82'), findsNothing);
      expect(find.bySemanticsLabel('/100'), findsNothing);
      handle.dispose();
    });

    testWidgets('ScoreRing accepts an overriding label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(harness(
        const ScoreRing(score: 40, semanticLabel: 'Skin health 40 percent'),
      ));
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel('Skin health 40 percent'),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('StatusView', () {
    testWidgets('error state renders message and retry action',
        (tester) async {
      var retried = false;
      await tester.pumpWidget(harness(
        StatusView.error(
          message: 'Could not load analysis.',
          onRetry: () => retried = true,
        ),
      ));
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Could not load analysis.'), findsOneWidget);
      await tester.tap(find.text('Try Again'));
      expect(retried, isTrue);
    });

    testWidgets('offline state uses its default copy', (tester) async {
      await tester.pumpWidget(harness(const StatusView.offline()));
      expect(find.text('You are offline'), findsOneWidget);
    });
  });

  group('StatusView.forError', () {
    testWidgets('a dropped connection reads as offline, not as an error',
        (tester) async {
      await tester.pumpWidget(harness(
        StatusView.forError(
          const NetworkException(),
          fallbackMessage: 'Could not load your history.',
        ),
      ));

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.text('Something went wrong'), findsNothing);
      expect(
        find.text('No internet connection. Please check your network.'),
        findsOneWidget,
      );
    });

    testWidgets('a timeout also reads as offline', (tester) async {
      await tester.pumpWidget(harness(
        StatusView.forError(
          const TimeoutException(),
          fallbackMessage: 'Could not load your history.',
        ),
      ));
      expect(find.text('You are offline'), findsOneWidget);
    });

    testWidgets('a server failure surfaces its own message', (tester) async {
      await tester.pumpWidget(harness(
        StatusView.forError(
          const ServerException('Analysis engine is unavailable.'),
          fallbackMessage: 'Could not load this analysis.',
        ),
      ));

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Analysis engine is unavailable.'), findsOneWidget);
    });

    testWidgets('an untyped error falls back to the caller message',
        (tester) async {
      await tester.pumpWidget(harness(
        StatusView.forError(
          Exception('boom'),
          fallbackMessage: 'Could not load this analysis.',
        ),
      ));

      expect(find.text('Could not load this analysis.'), findsOneWidget);
      // The raw exception text must never reach the user.
      expect(find.textContaining('boom'), findsNothing);
    });

    testWidgets('retry is wired through to the caller', (tester) async {
      var retried = false;
      await tester.pumpWidget(harness(
        StatusView.forError(
          const NetworkException(),
          fallbackMessage: 'Could not load.',
          onRetry: () => retried = true,
        ),
      ));

      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });
  });
}
