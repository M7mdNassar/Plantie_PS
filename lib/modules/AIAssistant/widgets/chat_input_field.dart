import 'package:flutter/material.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import '../../../generated/l10n.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;
  final bool isEnabled;
  final FocusNode focusNode;

  const ChatInputField({
    super.key,
    required this.onSend,
    required this.isLoading,
    this.isEnabled = true,
    required this.focusNode,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (!widget.isEnabled || widget.isLoading) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = !widget.isEnabled || widget.isLoading;
    final hint = widget.isEnabled
        ? S.of(context).typeMessage
        : S.of(context).noFreeMessages; // or "Watch ad to continue"

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey[300]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              enabled: !isDisabled,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: isDisabled
                    ? const Icon(Icons.lock_outline, size: 20, color: Colors.grey)
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDisabled
                    ? (isDark ? Colors.grey[800] : Colors.grey[200])
                    : (isDark ? AppColors.darkSurfaceVariant : Colors.grey[100]),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                hintStyle: TextStyle(
                  color: isDisabled
                      ? (isDark ? Colors.grey[600] : Colors.grey[400])
                      : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isDisabled ? null : _send,
            icon: widget.isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
                : Icon(
              Icons.send_rounded,
              color: isDisabled ? Colors.grey : AppColors.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}