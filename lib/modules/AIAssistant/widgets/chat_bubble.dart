import 'package:flutter/material.dart';
import 'package:plantie/models/chat_message.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import '../../../shared/styles/responsive_text.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? (isDark ? AppColors.primaryLight : AppColors.primary)
                    : (isDark ? AppColors.darkSurfaceVariant : Colors.grey[200]),
                borderRadius: BorderRadius.only(
                  topLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  topRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
              ),
              child: SelectableText(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
                  fontSize: ResponsiveText.body(context),
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser) _buildAvatar(context, isUser: true),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, {bool isUser = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser
          ? AppColors.primary
          : (isDark ? AppColors.darkSurfaceVariant : Colors.grey[300]),
      child: Icon(
        isUser ? Icons.person : Icons.auto_awesome,
        size: 18,
        color: isUser ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
      ),
    );
  }
}