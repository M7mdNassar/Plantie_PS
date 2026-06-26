import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:plantie/models/chat_message.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'package:plantie/shared/styles/responsive_text.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colors
    final userColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final assistantColor = isDark ? AppColors.darkSurfaceVariant : Colors.grey[200]!;
    final textColor = isUser ? Colors.white : (isDark ? Colors.white : Colors.black87);

    // Markdown style sheet
    final markdownStyle = MarkdownStyleSheet(
      p: TextStyle(
        color: textColor,
        fontSize: ResponsiveText.body(context),
        height: 1.5,
      ),
      h1: TextStyle(
        color: textColor,
        fontSize: ResponsiveText.headlineSmall(context),
        fontWeight: FontWeight.bold,
      ),
      h2: TextStyle(
        color: textColor,
        fontSize: ResponsiveText.title(context),
        fontWeight: FontWeight.bold,
      ),
      h3: TextStyle(
        color: textColor,
        fontSize: ResponsiveText.body(context),
        fontWeight: FontWeight.bold,
      ),
      strong: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      em: TextStyle(
        color: textColor,
        fontStyle: FontStyle.italic,
      ),
      a: TextStyle(
        color: isUser ? Colors.white : AppColors.primary,
        decoration: TextDecoration.underline,
      ),
      code: TextStyle(
        color: isUser ? Colors.white70 : (isDark ? Colors.grey[300] : Colors.black54),
        fontFamily: 'monospace',
        fontSize: ResponsiveText.labelSmall(context),
      ),
      // ✅ blockquote is a TextStyle (for the text inside blockquote)
      blockquote: TextStyle(
        color: textColor,
        fontSize: ResponsiveText.body(context),
      ),
      // ✅ blockquoteDecoration is a BoxDecoration (for the container)
      blockquoteDecoration: BoxDecoration(
        color: (isUser ? Colors.white : (isDark ? Colors.grey[800]! : Colors.grey[200]!))
            .withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(
            color: (isUser ? Colors.white : (isDark ? Colors.grey[500]! : Colors.grey[400]!))
                .withOpacity(0.5),
            width: 3,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      listBullet: TextStyle(
        color: textColor,
        fontSize: ResponsiveText.body(context),
      ),
    );

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
                color: isUser ? userColor : assistantColor,
                borderRadius: BorderRadius.only(
                  topLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  topRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
              ),
              child: MarkdownBody(
                data: message.content,
                styleSheet: markdownStyle,
                selectable: true,
                onTapLink: (text, href, title) {
                  // Optional: handle link taps (e.g., launch URL)
                },
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
          : (isDark ? AppColors.darkSurfaceVariant : Colors.grey[300]!),
      child: Icon(
        isUser ? Icons.person : Icons.auto_awesome,
        size: 18,
        color: isUser ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
      ),
    );
  }
}