import 'package:equatable/equatable.dart';
import '../../../models/chat_message.dart';

abstract class AIChatState extends Equatable {
  const AIChatState();

  @override
  List<Object?> get props => [];
}

class AIChatInitial extends AIChatState {
  final List<ChatMessage> messages;
  final String? sessionId;

  const AIChatInitial({this.messages = const [], this.sessionId});

  @override
  List<Object?> get props => [messages, sessionId];
}

class AIChatLoading extends AIChatState {
  final List<ChatMessage> messages;

  const AIChatLoading(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AIChatStreaming extends AIChatState {
  final List<ChatMessage> messages;
  final String partialResponse;

  const AIChatStreaming(this.messages, this.partialResponse);

  @override
  List<Object?> get props => [messages, partialResponse];
}

class AIChatSuccess extends AIChatState {
  final List<ChatMessage> messages;

  const AIChatSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AIChatError extends AIChatState {
  final String error;
  final List<ChatMessage> messages;

  const AIChatError(this.error, this.messages);

  @override
  List<Object?> get props => [error, messages];
}