import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/AIAssistant/cubit/ai_chat_cubit.dart';
import 'package:plantie/modules/AIAssistant/cubit/ai_chat_state.dart';
import 'package:plantie/modules/AIAssistant/widgets/chat_bubble.dart';
import 'package:plantie/modules/AIAssistant/widgets/chat_input_field.dart';
import 'package:plantie/modules/AIAssistant/widgets/typing_indicator.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'package:plantie/shared/styles/responsive_text.dart';
import '../../generated/l10n.dart';
import '../../models/chat_message.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => AIChatCubit(),
      child: BlocConsumer<AIChatCubit, AIChatState>(
        listener: (context, state) {
          if (state is AIChatStreaming || state is AIChatSuccess) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          final cubit = context.read<AIChatCubit>();

          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).aiAssistant),
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _showClearDialog(context, cubit),
                  tooltip: S.of(context).clearChat,
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: _buildMessageList(context, state, cubit),
                ),
                ChatInputField(
                  onSend: (text) => cubit.sendMessage(text),
                  isLoading: state is AIChatLoading || state is AIChatStreaming,
                  focusNode: _focusNode,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, AIChatState state, AIChatCubit cubit) {
    List<ChatMessage> messages = [];
    String? partialResponse;

    if (state is AIChatInitial) messages = state.messages;
    if (state is AIChatLoading) messages = state.messages;
    if (state is AIChatStreaming) {
      messages = state.messages;
      partialResponse = state.partialResponse;
    }
    if (state is AIChatSuccess) messages = state.messages;
    if (state is AIChatError) messages = state.messages;

    if (messages.isEmpty && state is! AIChatStreaming) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length + (state is AIChatStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        if (state is AIChatStreaming && index == messages.length) {
          // Show typing indicator
          return const TypingIndicator();
        }
        final message = messages[index];
        return ChatBubble(message: message);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).aiAssistantEmptyTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).aiAssistantEmptySubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, AIChatCubit cubit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).clearChat),
        content: Text(S.of(context).clearChatConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.clearConversation();
            },
            child: Text(
              S.of(context).clear,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}