import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantie/models/post/post_model.dart';
import 'package:plantie/shared/network/remote/supabase_service.dart';
import 'package:plantie/shared/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../generated/l10n.dart';
import '../../models/user/user_model.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  late FocusNode _focusNode;
  final ValueNotifier<List<CommentModel>> _commentsNotifier = ValueNotifier([]);
  bool _isSubmitting = false;
  bool _isLoadingComments = true;
  RealtimeChannel? _commentsChannel;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadInitialComments();
    _subscribeToCommentChanges();
  }

  Future<void> _loadInitialComments() async {
    try {
      final response = await supabaseService.client
          .from('comments')
          .select('*, users(name, image)')  // ✅ JOIN to get user data in one query
          .eq('post_id', widget.postId)
          .order('created_at', ascending: false);

      final comments = response.map((json) {
        final user = json['users'] ?? {};
        return CommentModel(
          commentId: json['id'].toString(),
          userId: json['user_id'].toString(),
          userName: user['name']?.toString() ?? 'User',
          userImage: user['image']?.toString(),
          text: json['text'].toString(),
          timestamp: DateTime.parse(json['created_at']),
        );
      }).toList();

      _commentsNotifier.value = comments;
      if (mounted) setState(() => _isLoadingComments = false);
    } catch (e) {
      debugPrint('❌ Load comments error: $e');
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

  void _subscribeToCommentChanges() {
    debugPrint('🔔 [SUBSCRIBE] Setting up real‑time comments for post ${widget.postId}...');

    try {
      _commentsChannel = supabaseService.client
          .channel('comments:${widget.postId}')
          .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'comments',
        // ✅ Server‑side filter – only receive events for this specific post
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'post_id',
          value: widget.postId,
        ),
        callback: (payload) async {
          final eventType = payload.eventType.toString().toUpperCase();

          if (eventType.contains('INSERT')) {
            try {
              final newCommentRaw = payload.newRecord;
              // Fetch user info for the comment author
              final userResponse = await supabaseService.client
                  .from('users')
                  .select('name, image')
                  .eq('id', newCommentRaw['user_id'])
                  .single();

              final newComment = CommentModel(
                commentId: newCommentRaw['id'].toString(),
                userId: newCommentRaw['user_id'].toString(),
                userName: userResponse['name']?.toString() ?? 'User',
                userImage: userResponse['image']?.toString(),
                text: newCommentRaw['text'].toString(),
                timestamp: DateTime.parse(newCommentRaw['created_at']),
              );

              // Remove any optimistic comment that matches this new one (same user, same text)
              final current = _commentsNotifier.value;
              final filtered = current.where((c) =>
              !(c.commentId.startsWith('temp-') &&
                  c.userId == newComment.userId &&
                  c.text == newComment.text)).toList();

              _commentsNotifier.value = [newComment, ...filtered];
              debugPrint('✅ Real‑time comment added: ${newComment.commentId}');
            } catch (e) {
              debugPrint('❌ Error processing INSERT comment: $e');
            }
          }
          else if (eventType.contains('DELETE')) {
            try {
              final deletedId = payload.oldRecord['id'].toString();
              final current = _commentsNotifier.value;
              _commentsNotifier.value = current.where((c) => c.commentId != deletedId).toList();
              debugPrint('✅ Real‑time comment deleted: $deletedId');
            } catch (e) {
              debugPrint('❌ Error processing DELETE comment: $e');
            }
          }
        },
      )
          .subscribe();
    } catch (e) {
      debugPrint('❌ Error setting up comment subscription: $e');
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _commentsNotifier.dispose();
    if (_commentsChannel != null) {
      supabaseService.client.removeChannel(_commentsChannel!);
    }
    super.dispose();
  }

  String _getRelativeTime(BuildContext context, DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (diff.inSeconds < 60) return isArabic ? 'منذ لحظات' : 'moments ago';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return isArabic ? 'منذ $m دقيقة' : '$m min ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return isArabic ? 'منذ $h ساعة' : '$h hour${h > 1 ? 's' : ''} ago';
    }
    if (diff.inDays < 7) {
      final d = diff.inDays;
      return isArabic ? 'منذ $d يوم' : '$d day${d > 1 ? 's' : ''} ago';
    }
    return DateFormat('d MMM').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = CommunityCubit.get(context);
    final currentUser = CurrentUser.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).comments),
        elevation: 0.5,
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<CommentModel>>(
              valueListenable: _commentsNotifier,
              builder: (context, comments, _) {
                if (_isLoadingComments) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                }
                if (comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(S.of(context).noCommentsYet,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(S.of(context).beFirstToComment,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600])),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  key: PageStorageKey('comments-${widget.postId}'),
                  cacheExtent: 600,
                  physics: const BouncingScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) =>
                      _buildCommentTile(context, comments[index]),
                );
              },
            ),
          ),
          Container(height: 0.5, color: Colors.grey[300]),
          Container(
            color: isDark ? Colors.grey[850] : Colors.white,
            padding: EdgeInsets.fromLTRB(12, 14, 12,
                34 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isSubmitting)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(plantieColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(S.of(context).postingComment,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: plantieColor)),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: plantieColor.withOpacity(0.2),
                      backgroundImage: (currentUser.image?.isNotEmpty ?? false)
                          ? NetworkImage(currentUser.image!)
                          : const AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _focusNode,
                        enabled: !_isSubmitting,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) =>
                            _submitComment(context, cubit, currentUser),
                        decoration: InputDecoration(
                          hintText: S.of(context).write_comment,
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey[300]!)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.grey[300]!, width: 0.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                              BorderSide(color: plantieColor, width: 1.5)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                              BorderSide(color: Colors.grey[300]!, width: 0.5)),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          filled: true,
                          fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isSubmitting
                            ? null
                            : () => _submitComment(context, cubit, currentUser),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _isSubmitting
                              ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                AlwaysStoppedAnimation(plantieColor)),
                          )
                              : Icon(IconBroken.Send, color: plantieColor, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(BuildContext context, CommentModel comment) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: plantieColor.withOpacity(0.2),
            backgroundImage: (comment.userImage?.isNotEmpty ?? false)
                ? NetworkImage(comment.userImage!)
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.userName,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(comment.text, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(_getRelativeTime(context, comment.timestamp),
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: Colors.grey[600])),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitComment(
      BuildContext context, CommunityCubit cubit, UserModel currentUser) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    // Optimistic comment
    final optimistic = CommentModel(
      commentId: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      userId: currentUser.id,
      userName: currentUser.name,
      userImage: currentUser.image,
      text: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _isSubmitting = true;
      _commentController.clear();
      _focusNode.unfocus();
    });

    // Add optimistic to UI
    _commentsNotifier.value = [optimistic, ..._commentsNotifier.value];

    try {
      await cubit.addComment(
        postId: widget.postId,
        text: text,
        userId: currentUser.id,
        userName: currentUser.name,
        userImage: currentUser.image,
      );
      // Real-time event will replace the optimistic comment automatically
    } catch (e) {
      // Remove optimistic on failure
      _commentsNotifier.value = _commentsNotifier.value
          .where((c) => !c.commentId.startsWith('temp-'))
          .toList();
      if (mounted) {
        NotificationService.error(
          title: 'Failed',
          message: 'Could not post comment. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}