import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/safe_api_call.dart';
import '../../../ingredients/domain/ingredient.dart';

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    this.ingredient,
    this.pending = false,
    this.isError = false,
  });

  final String text;
  final bool isUser;

  /// Attached when the backend answered from a database ingredient, so the
  /// UI can offer "view details".
  final Ingredient? ingredient;

  /// A placeholder bubble shown while the reply is in flight.
  final bool pending;

  /// A failed request rather than an assistant answer, styled accordingly.
  final bool isError;
}

/// Skincare assistant backed by POST /chat — Claude when the backend has
/// an AI key, database-grounded answers otherwise. When [arg] carries an
/// analysis id, every question is answered in that product's context.
class AssistantViewModel extends Notifier<List<ChatMessage>> {
  AssistantViewModel(this.analysisId);

  final String? analysisId;
  bool _busy = false;

  @override
  List<ChatMessage> build() => [
        ChatMessage(
          text: analysisId == null
              ? 'Hi! Ask me anything about skincare ingredients — try '
                  '"What is niacinamide?" or "Is fragrance safe for me?"'
              : 'Ask me anything about this product — its score, its '
                  'ingredients, or what to use instead.',
          isUser: false,
        ),
      ];

  Future<void> send(String input) async {
    final question = input.trim();
    if (question.isEmpty || _busy) return;
    _busy = true;
    state = [
      ...state,
      ChatMessage(text: question, isUser: true),
      const ChatMessage(text: '…', isUser: false, pending: true),
    ];
    try {
      final dio = ref.read(dioProvider);
      final data = await safeApiCall(() async {
        final response = await dio.post<Map<String, dynamic>>(
          ApiEndpoints.chat,
          data: {
            'message': question,
            if (analysisId != null) 'analysisId': analysisId,
          },
        );
        return response.data!['data'] as Map<String, dynamic>;
      });
      final ingredientJson = data['ingredient'];
      state = [
        ...state.where((m) => !m.pending),
        ChatMessage(
          text: data['reply'] as String,
          isUser: false,
          ingredient: ingredientJson is Map<String, dynamic>
              ? Ingredient.fromJson(ingredientJson)
              : null,
        ),
      ];
    } on AppException catch (error) {
      // Surface the real failure — an offline device, a rate limit and a
      // server fault are different problems and read differently.
      state = [
        ...state.where((m) => !m.pending),
        ChatMessage(text: error.message, isUser: false, isError: true),
      ];
    } catch (_) {
      state = [
        ...state.where((m) => !m.pending),
        const ChatMessage(
          text: 'Something went wrong reaching the assistant. Please try again.',
          isUser: false,
          isError: true,
        ),
      ];
    } finally {
      _busy = false;
    }
  }
}

final assistantViewModelProvider =
    NotifierProvider.family<AssistantViewModel, List<ChatMessage>, String?>(
  AssistantViewModel.new,
);
