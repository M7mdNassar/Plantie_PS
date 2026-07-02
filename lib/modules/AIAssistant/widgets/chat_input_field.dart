import 'package:flutter/material.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import '../../../generated/l10n.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;
  final bool isEnabled;
  final FocusNode focusNode;
  final ValueNotifier<bool>? highlightNotifier;

  const ChatInputField({
    super.key,
    required this.onSend,
    required this.isLoading,
    this.isEnabled = true,
    required this.focusNode,
    this.highlightNotifier,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _highlightController;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _highlightController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _highlightController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _highlightController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    widget.highlightNotifier?.addListener(_onHighlightChanged);
  }

  void _onHighlightChanged() {
    if (widget.highlightNotifier!.value) {
      _highlightController.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _highlightController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _highlightController.dispose();
    widget.highlightNotifier?.removeListener(_onHighlightChanged);
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
        : S.of(context).noFreeMessages;

    return AnimatedBuilder(
      animation: _highlightController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 8, 10, 35),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _borderColorAnimation.value ?? Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: widget.focusNode,
                      enabled: !isDisabled,
                      minLines: 1,
                      maxLines: 5, // Maximum height – expand up to 5 lines
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        hintStyle: TextStyle(
                          color: isDisabled
                              ? (isDark ? Colors.grey[600] : Colors.grey[400])
                              : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: IconButton(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}