import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/AIAssistant/cubit/ai_chat_cubit.dart';
import 'package:plantie/modules/AIAssistant/cubit/ai_chat_state.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import '../../../generated/l10n.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AIChatCubit>().loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).conversations),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      body: BlocConsumer<AIChatCubit, AIChatState>(
        listener: (context, state) {
          if (state is AIChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AIChatCubit>();
          final conversations = cubit.conversations;

          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).noConversations,
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conv = conversations[index];
              final title = conv['title'] ?? 'New Chat';
              final lastMsg = conv['last_message_at'] ?? '';
              return ListTile(
                leading: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                title: Text(title),
                subtitle: Text(lastMsg, style: const TextStyle(fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(context, cubit, conv['id']),
                ),
                onTap: () {
                  Navigator.pop(context, conv['id']);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AIChatCubit cubit, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).deleteConversation),
        content: Text(S.of(context).deleteConversationConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.deleteConversation(id);
            },
            child: Text(S.of(context).delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}