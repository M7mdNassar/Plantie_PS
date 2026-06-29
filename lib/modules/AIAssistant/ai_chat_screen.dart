import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/AIAssistant/cubit/ai_chat_cubit.dart';
import 'package:plantie/modules/AIAssistant/cubit/ai_chat_state.dart';
import 'package:plantie/modules/AIAssistant/widgets/chat_bubble.dart';
import 'package:plantie/modules/AIAssistant/widgets/chat_input_field.dart';
import 'package:plantie/modules/AIAssistant/widgets/typing_indicator.dart';
import 'package:plantie/shared/styles/app_colors.dart';
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
          if (state is AIChatAdRewardSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).rewardReceived(state.remainingFreeChats)),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          // --- Updated error handling with translations ---
          if (state is AIChatError) {
            String errorMessage;
            // Check for specific ad error codes
            if (state.error == 'ad_failed_to_show') {
              errorMessage = S.of(context).adFailedToShow;
            } else if (state.error == 'ad_not_available') {
              errorMessage = S.of(context).adNotAvailable;
            } else {
              // Default: show the raw error message (or you can add more cases)
              errorMessage = state.error;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AIChatCubit>();
          final hasNoAttempts = state.remainingFreeChats <= 0 &&
              state is! AIChatStreaming &&
              state is! AIChatLoading;
          final isAdLoading = state is AIChatAdLoading;
          final canType = !hasNoAttempts && !isAdLoading && state is! AIChatLoading && state is! AIChatStreaming;

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(S.of(context).aiAssistant),
                  const Spacer(),
                  // Modern pill badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: hasNoAttempts ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasNoAttempts ? Icons.lock_outline : Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hasNoAttempts
                              ? S.of(context).noFreeMessagesShort
                              : S.of(context).freeCount(state.remainingFreeChats),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // "Get More" button (always visible)
                  if (hasNoAttempts)
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                      onPressed: cubit.watchAdToGetMore,
                      tooltip: S.of(context).watchAdButton,
                    ),
                ],
              ),
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
                // Banner when no attempts left
                if (hasNoAttempts)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    color: Colors.orange[100],
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            S.of(context).noFreeMessages,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                        TextButton(
                          onPressed: isAdLoading ? null : cubit.watchAdToGetMore,
                          child: isAdLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.orange,
                            ),
                          )
                              : Text(
                            S.of(context).watchAdButton,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _buildMessageList(context, state, cubit),
                ),
                ChatInputField(
                  onSend: (text) {
                    if (!canType) {
                      // Should not happen because field is disabled, but safety
                      if (hasNoAttempts) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).noFreeMessages),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                      return;
                    }
                    cubit.sendMessage(text);
                  },
                  isLoading: state is AIChatLoading || state is AIChatStreaming || isAdLoading,
                  isEnabled: canType,
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
    if (state is AIChatInitial) messages = state.messages;
    if (state is AIChatLoading) messages = state.messages;
    if (state is AIChatStreaming) messages = state.messages;
    if (state is AIChatSuccess) messages = state.messages;
    if (state is AIChatError) messages = state.messages;
    if (state is AIChatAdRewardSuccess) messages = state.messages;
    if (state is AIChatAdLoading) messages = state.messages;

    if (messages.isEmpty && state is! AIChatStreaming) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length + (state is AIChatStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        if (state is AIChatStreaming && index == messages.length) {
          return const TypingIndicator();
        }
        final message = messages[index];
        // Use key for performance
        return ChatBubble(key: ValueKey(message.id), message: message);
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