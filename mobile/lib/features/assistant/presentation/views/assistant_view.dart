import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../ingredients/presentation/widgets/ingredient_detail_sheet.dart';
import '../viewmodels/assistant_viewmodel.dart';

class AssistantView extends ConsumerStatefulWidget {
  const AssistantView({super.key, this.analysisId, this.productName});

  /// When set, the conversation is grounded in this analysis ("Ask AI").
  final String? analysisId;
  final String? productName;

  @override
  ConsumerState<AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends ConsumerState<AssistantView> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.analysisId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messages =
            ref.read(assistantViewModelProvider(widget.analysisId));
        if (messages.length <= 1) {
          ref
              .read(assistantViewModelProvider(widget.analysisId).notifier)
              .send(
                'Why did ${widget.productName ?? 'this product'} get this score?',
              );
        }
      });
    }
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    await ref
        .read(assistantViewModelProvider(widget.analysisId).notifier)
        .send(text);
  }

  /// Runs after the frame that added the message, so [maxScrollExtent]
  /// already accounts for the new bubble.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: AppDurations.normal,
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(assistantViewModelProvider(widget.analysisId));
    // Follow the conversation on every change — the outgoing message, the
    // pending placeholder, and the reply each need to scroll into view.
    ref.listen(
      assistantViewModelProvider(widget.analysisId),
      (_, _) => _scrollToBottom(),
    );
    final isSending = messages.any((m) => m.pending);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.analysisId == null
              ? 'AI Assistant'
              : 'Ask AI · ${widget.productName ?? 'Analysis'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scroll,
                padding: const EdgeInsets.all(AppSpacing.screen),
                itemCount: messages.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) =>
                    _MessageBubble(message: messages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.base,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      enabled: !isSending,
                      decoration: InputDecoration(
                        hintText: isSending
                            ? 'Waiting for a reply…'
                            : 'Ask anything about skincare…',
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Sending is serialised in the ViewModel; reflect that here
                  // so a second tap is visibly unavailable rather than a no-op.
                  Container(
                    decoration: BoxDecoration(
                      gradient: isSending ? null : AppGradients.primary,
                      color: isSending
                          ? Theme.of(context).colorScheme.surfaceContainerHigh
                          : null,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: IconButton(
                      onPressed: isSending ? null : _send,
                      tooltip: isSending ? 'Waiting for a reply' : 'Send',
                      icon: isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: AppColors.onMint,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: message.isUser ? AppGradients.accent : null,
          color: message.isUser
              ? null
              : message.isError
                  ? AppColors.danger.withValues(alpha: 0.12)
                  : theme.colorScheme.surfaceContainer,
          border: message.isError
              ? Border.all(color: AppColors.danger.withValues(alpha: 0.4))
              : null,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.md),
            topRight: const Radius.circular(AppRadius.md),
            bottomLeft: Radius.circular(message.isUser ? AppRadius.md : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : AppRadius.md),
          ),
        ),
        child: message.pending
            // A bare progress bar is silent to a screen reader.
            ? Semantics(
                label: 'Assistant is typing',
                liveRegion: true,
                child: const SizedBox(
                  width: 36,
                  child: LinearProgressIndicator(minHeight: 3),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: message.isUser
                          ? Colors.white
                          : message.isError
                              ? AppColors.danger
                              : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (message.ingredient != null)
                    TextButton(
                      onPressed: () => showIngredientDetail(
                        context,
                        message.ingredient!,
                      ),
                      child: const Text('View full breakdown →'),
                    ),
                ],
              ),
      ),
    );
  }
}
