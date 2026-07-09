import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/config/app_config.dart';
import 'package:plantie/config/config_manager.dart';
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
  final ValueNotifier<bool> _highlightInput = ValueNotifier<bool>(false);

  bool _configChecked = false;
  bool _chatEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkConfigAndSetup();
  }

  Future<void> _checkConfigAndSetup() async {
    // Fetch fresh config (non‑blocking)
    await ConfigManager().fetchIfNeeded();
    final enabled = AppConfig.isChatEnabled;
    setState(() {
      _chatEnabled = enabled;
      _configChecked = true;
    });

    // If chat is disabled, show a dialog (but we'll also show a disabled UI)
    if (!enabled && mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(S.of(ctx).chat_unavailable_title),
          content: Text(S.of(ctx).chat_unavailable_subtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(S.of(ctx).ok),
            ),
          ],
        ),
      );
      // Optionally, we could pop the screen after dialog, but we keep it to show disabled UI.
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    _highlightInput.dispose();
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

  void _showRewardNotification(BuildContext context, int remaining) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentMaterialBanner();

    final banner = MaterialBanner(
      content: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              S.of(context).rewardReceived(remaining),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.success,
      leading: const SizedBox.shrink(),
      actions: [
        TextButton(
          onPressed: () => messenger.hideCurrentMaterialBanner(),
          child: Text(
            S.of(context).ok,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 8,
    );

    messenger.showMaterialBanner(banner);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        messenger.hideCurrentMaterialBanner();
      }
    });
  }

  void _triggerInputHighlight() {
    _highlightInput.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _highlightInput.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_configChecked) {
      return Scaffold(
        appBar: AppBar(title: Text(S.of(context).aiAssistant)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If chat is disabled, show a dedicated disabled screen
    if (!_chatEnabled) {
      return _buildDisabledScreen(context);
    }

    // Normal chat screen (enabled)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => AIChatCubit(),
      child: BlocConsumer<AIChatCubit, AIChatState>(
        listener: (context, state) {
          if (state is AIChatStreaming || state is AIChatSuccess) {
            _scrollToBottom();
          }
          if (state is AIChatAdRewardSuccess) {
            _showRewardNotification(context, state.remainingFreeChats);
            _triggerInputHighlight();
          }
          if (state is AIChatError) {
            String errorMessage;
            if (state.error == 'ad_failed_to_show') {
              errorMessage = S.of(context).adFailedToShow;
            } else if (state.error == 'ad_not_available') {
              errorMessage = S.of(context).adNotAvailable;
            } else if (state.error == 'offline_chat' || state.error == 'network_error') {
              errorMessage = S.of(context).chatOfflineMessage;
            } else {
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

          final bool isLoadingRemaining = cubit.isLoadingRemaining;

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(S.of(context).aiAssistant),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: hasNoAttempts ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isLoadingRemaining
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Row(
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
                  highlightNotifier: _highlightInput,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Disabled screen when chat feature is turned off remotely
  Widget _buildDisabledScreen(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).aiAssistant),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 72,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).chat_unavailable_title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).chat_unavailable_subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  // Try to fetch config again and refresh
                  await ConfigManager().fetchIfNeeded(force: true);
                  final enabled = AppConfig.isChatEnabled;
                  if (mounted) {
                    setState(() {
                      _chatEnabled = enabled;
                      _configChecked = true;
                    });
                  }
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(S.of(context).retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
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