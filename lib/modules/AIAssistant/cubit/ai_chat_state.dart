import 'package:equatable/equatable.dart';
import '../../../models/chat_message.dart';

abstract class AIChatState extends Equatable {
  final List<ChatMessage> messages;
  final String? sessionId;
  final int remainingFreeChats;
  final List<Map<String, dynamic>> conversations;
  final List<String> suggestions; // follow‑up suggestions

  const AIChatState({
    this.messages = const [],
    this.sessionId,
    this.remainingFreeChats = 3,
    this.conversations = const [],
    this.suggestions = const [],
  });

  @override
  List<Object?> get props => [messages, sessionId, remainingFreeChats, conversations, suggestions];
}

class AIChatInitial extends AIChatState {
  const AIChatInitial({
    List<ChatMessage> messages = const [],
    String? sessionId,
    int remainingFreeChats = 3,
    List<Map<String, dynamic>> conversations = const [],
    List<String> suggestions = const [],
  }) : super(
    messages: messages,
    sessionId: sessionId,
    remainingFreeChats: remainingFreeChats,
    conversations: conversations,
    suggestions: suggestions,
  );
}

class AIChatLoading extends AIChatState {
  const AIChatLoading({
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
    List<Map<String, dynamic>> conversations = const [],
    List<String> suggestions = const [],
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
    conversations: conversations,
    suggestions: suggestions,
  );
}

class AIChatStreaming extends AIChatState {
  final String partialResponse;
  const AIChatStreaming({
    required List<ChatMessage> messages,
    required this.partialResponse,
    int remainingFreeChats = 3,
    List<Map<String, dynamic>> conversations = const [],
    List<String> suggestions = const [],
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
    conversations: conversations,
    suggestions: suggestions,
  );

  @override
  List<Object?> get props => [messages, partialResponse, remainingFreeChats, conversations, suggestions];
}

class AIChatSuccess extends AIChatState {
  const AIChatSuccess({
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
    List<Map<String, dynamic>> conversations = const [],
    List<String> suggestions = const [],
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
    conversations: conversations,
    suggestions: suggestions,
  );
}

class AIChatError extends AIChatState {
  final String error;
  const AIChatError({
    required this.error,
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
    List<Map<String, dynamic>> conversations = const [],
    List<String> suggestions = const [],
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
    conversations: conversations,
    suggestions: suggestions,
  );

  @override
  List<Object?> get props => [error, messages, remainingFreeChats, conversations, suggestions];
}

class AIChatAdLoading extends AIChatState {
  const AIChatAdLoading({
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
    List<Map<String, dynamic>> conversations = const [],
    List<String> suggestions = const [],
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
    conversations: conversations,
    suggestions: suggestions,
  );
}

class AIChatAdRewardSuccess extends AIChatState {
  const AIChatAdRewardSuccess({
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
    List<Map<String, dynamic>> conversations = const [],
    List<String> suggestions = const [],
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
    conversations: conversations,
    suggestions: suggestions,
  );
}