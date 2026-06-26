import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../models/chat_message.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/network/local/chat_history_db.dart';
import '../ai_chat_service.dart';
import 'ai_chat_state.dart';

class AIChatCubit extends Cubit<AIChatState> {
  final AIChatService _service = AIChatService();
  final ChatHistoryDB _db = ChatHistoryDB();
  final String _sessionId;
  List<ChatMessage> _messages = [];
  StreamSubscription<String>? _subscription;
  String? _currentAssistantMessageId;

  AIChatCubit({String? sessionId})
      : _sessionId = sessionId ?? const Uuid().v4(),
        super(AIChatInitial()) {
    _loadConversation();
  }

  String get sessionId => _sessionId;

  Future<void> _loadConversation() async {
    final saved = await _db.getConversation(_sessionId);
    if (saved != null) {
      _messages = saved;
      emit(AIChatInitial(messages: _messages, sessionId: _sessionId));
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage.user(text.trim());
    _messages.add(userMessage);

    // Add a placeholder for assistant response
    final assistantPlaceholder = ChatMessage.assistant('');
    _messages.add(assistantPlaceholder);
    _currentAssistantMessageId = assistantPlaceholder.id;

    emit(AIChatLoading(_messages));

    try {
      final stream = _service.sendMessage(
        query: text,
        sessionId: _sessionId,
        userId: CurrentUser.user.id,
        latitude: 0, // TODO: get from location
        longitude: 0,
      );

      _subscription = stream.listen(
            (chunk) {
          // Update the last assistant message with the chunk
          final index = _messages.indexWhere((m) => m.id == _currentAssistantMessageId);
          if (index != -1) {
            final updated = _messages[index].copyWith(
              content: _messages[index].content + chunk,
            );
            _messages[index] = updated;
            emit(AIChatStreaming(_messages, updated.content));
          }
        },
        onDone: () {
          _subscription?.cancel();
          _subscription = null;
          _saveConversation();
          emit(AIChatSuccess(_messages));
        },
        onError: (error) {
          _subscription?.cancel();
          _subscription = null;
          // Remove the incomplete assistant message
          _messages.removeWhere((m) => m.id == _currentAssistantMessageId);
          emit(AIChatError(error.toString(), _messages));
        },
      );
    } catch (e) {
      _messages.removeWhere((m) => m.id == _currentAssistantMessageId);
      emit(AIChatError(e.toString(), _messages));
    }
  }

  Future<void> _saveConversation() async {
    await _db.saveConversation(_sessionId, _messages);
  }

  void clearConversation() async {
    _subscription?.cancel();
    _subscription = null;
    _messages.clear();
    await _db.deleteConversation(_sessionId);
    emit(AIChatInitial(messages: [], sessionId: _sessionId));
  }

  void retry() {
    // Retry the last user message
    final userMessages = _messages.where((m) => m.role == MessageRole.user).toList();
    if (userMessages.isNotEmpty) {
      final lastUser = userMessages.last;
      // Remove the failed assistant message (if any)
      _messages.removeWhere((m) => m.role == MessageRole.assistant && m.content.isEmpty);
      sendMessage(lastUser.content);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _saveConversation();
    return super.close();
  }
}