import 'package:equatable/equatable.dart';
import '../../../models/chat_message.dart';

abstract class AIChatState extends Equatable {
  final List<ChatMessage> messages;
  final String? sessionId;
  final int remainingFreeChats;

  const AIChatState({
    this.messages = const [],
    this.sessionId,
    this.remainingFreeChats = 3,
  });

  @override
  List<Object?> get props => [messages, sessionId, remainingFreeChats];
}

class AIChatInitial extends AIChatState {
  const AIChatInitial({
    List<ChatMessage> messages = const [],
    String? sessionId,
    int remainingFreeChats = 3,
  }) : super(
    messages: messages,
    sessionId: sessionId,
    remainingFreeChats: remainingFreeChats,
  );
}

class AIChatLoading extends AIChatState {
  const AIChatLoading({
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
  );
}

class AIChatStreaming extends AIChatState {
  final String partialResponse;
  const AIChatStreaming({
    required List<ChatMessage> messages,
    required this.partialResponse,
    int remainingFreeChats = 3,
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
  );

  @override
  List<Object?> get props => [messages, partialResponse, remainingFreeChats];
}

class AIChatSuccess extends AIChatState {
  const AIChatSuccess({
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
  );
}

class AIChatError extends AIChatState {
  final String error;
  const AIChatError({
    required this.error,
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
  );
}

class AIChatAdLoading extends AIChatState {
  const AIChatAdLoading({
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
  );
}

class AIChatAdRewardSuccess extends AIChatState {
  const AIChatAdRewardSuccess({
    required List<ChatMessage> messages,
    int remainingFreeChats = 3,
  }) : super(
    messages: messages,
    remainingFreeChats: remainingFreeChats,
  );
}