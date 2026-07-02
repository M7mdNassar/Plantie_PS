import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:plantie/models/post/post_model.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/modules/Community/comment_screen.dart';
import 'package:plantie/modules/Community/image_carousel.dart';
import 'package:plantie/modules/UserView/user_profile_screen.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'package:readmore/readmore.dart';
import 'package:plantie/shared/utils/animations.dart';
import '../../generated/l10n.dart';
import '../../shared/network/remote/supabase_service.dart';
import '../../shared/network/remote/supabase_auth_service.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isOffline = false;
  PostModel? _post;
  late AnimationController _likeAnimationController;
  bool _isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadPost();
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadPost() async {
    setState(() {
      _isLoading = true;
      _isOffline = false;
    });

    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isOffline = true;
        });
      }
      return;
    }

    try {
      final response = await supabaseService.client
          .from('posts')
          .select('*, users(*), post_images(*)')
          .eq('id', widget.postId)
          .single();
      final post = PostModel.fromJson(response);
      final currentUserId = CurrentUser.user.id;
      if (currentUserId.isNotEmpty) {
        final likesResponse = await supabaseService.client
            .from('post_likes')
            .select('post_id')
            .eq('user_id', currentUserId)
            .eq('post_id', widget.postId)
            .maybeSingle();
        _post = post.copyWith(userLiked: likesResponse != null);
      } else {
        _post = post;
      }
    } catch (e) {
      debugPrint('Error loading post: $e');
      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('network is unreachable')) {
        setState(() => _isOffline = true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleLike(PostModel post) async {
    if (_isLikeAnimating) return;
    _isLikeAnimating = true;

    final currentUser = CurrentUser.user;
    if (currentUser.id.isEmpty) {
      _isLikeAnimating = false;
      return;
    }

    final willLike = !post.userLiked;
    setState(() {
      post.likeCount += willLike ? 1 : -1;
      post.userLiked = willLike;
    });

    if (willLike) {
      _likeAnimationController.forward(from: 0);
    }

    try {
      if (willLike) {
        await supabaseService.client.from('post_likes').insert({
          'post_id': post.postId,
          'user_id': currentUser.id,
        });
      } else {
        await supabaseService.client
            .from('post_likes')
            .delete()
            .eq('post_id', post.postId)
            .eq('user_id', currentUser.id);
      }
    } catch (e) {
      setState(() {
        post.likeCount += willLike ? -1 : 1;
        post.userLiked = !willLike;
      });
      debugPrint('Error toggling like: $e');
    } finally {
      _isLikeAnimating = false;
    }
  }

  Future<void> _deletePost() async {
    try {
      await supabaseService.client.from('posts').delete().eq('id', _post!.postId);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint('Error deleting post: $e');
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(ctx).deletePostQuestion),
        content: Text(S.of(ctx).deletePostConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deletePost();
            },
            child: Text(S.of(ctx).delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = S.of(context);

    if (_isOffline) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          title: Text(s.postDetails),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: _buildOfflineState(context),
      );
    }

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          title: Text(s.postDetails),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_post == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          title: Text(s.postDetails),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.post_add_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(s.postNotFound, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      );
    }

    final post = _post!;
    final author = post.author;
    final isOwner = post.uId == CurrentUser.user.id;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(s.postDetails),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (isOwner)
            IconButton(
              icon: Icon(Icons.more_horiz, color: isDark ? Colors.white70 : Colors.black54),
              onPressed: () => _showDeleteConfirmation(context),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── HEADER ───
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => navigateTo(
                              context,
                              UserProfileScreen(userId: post.uId, userName: author?.name),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.primaryLight],
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primary.withOpacity(0.2),
                                backgroundImage: (author?.image != null && author!.image!.isNotEmpty)
                                    ? CachedNetworkImageProvider(author.image!)
                                    : null,
                                child: (author?.image == null || author!.image!.isEmpty)
                                    ? const Icon(Icons.person, color: Colors.white, size: 28)
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => navigateTo(
                                context,
                                UserProfileScreen(userId: post.uId, userName: author?.name),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    author?.name ?? 'User',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy • h:mm a').format(post.dateTime),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ─── POST TEXT ───
                    if (post.text != null && post.text!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ReadMoreText(
                          post.text!,
                          trimMode: TrimMode.Line,
                          trimLines: 8,
                          colorClickableText: AppColors.primary,
                          trimCollapsedText: s.showMore,
                          trimExpandedText: s.showLess,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.7,
                            fontSize: 15,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                          moreStyle: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          lessStyle: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // ─── IMAGES ───
                    if (post.postImage != null && post.postImage!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ImageCarousel(imageUrls: post.postImage!),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // ─── STATS ROW ───
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: (isDark ? Colors.white : Colors.black).withOpacity(0.06),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildStatItem(
                            Icons.thumb_up_off_alt,
                            post.likeCount,
                            color: post.userLiked ? AppColors.primary : AppColors.primary,
                          ),
                          const SizedBox(width: 20),
                          _buildStatItem(
                            Icons.chat_bubble_outline_rounded,
                            post.commentCount,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ─── BOTTOM ACTION BAR ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleLike(post),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: post.userLiked
                              ? AppColors.primary.withOpacity(0.1)
                              : (isDark ? Colors.white10 : Colors.grey[100]),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: post.userLiked ? AppColors.primary : Colors.transparent,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            ScaleTransition(
                              scale: _likeAnimationController.drive(
                                Tween<double>(begin: 1.0, end: 1.2).chain(
                                  CurveTween(curve: Curves.elasticOut),
                                ),
                              ),
                              child: Icon(
                                post.userLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                                color: post.userLiked ? AppColors.primary : (isDark ? Colors.white70 : Colors.grey[600]),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              post.likeCount.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: post.userLiked ? AppColors.primary : (isDark ? Colors.white70 : Colors.grey[600]),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.userLiked ? s.unlikePost : s.likePost,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: post.userLiked ? AppColors.primary : (isDark ? Colors.white70 : Colors.grey[600]),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => navigateTo(
                          context,
                          CommentScreen(postId: post.postId),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.grey[100],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: isDark ? Colors.white70 : Colors.grey[600],
                                size: 22,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                S.of(context).comment,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineState(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey[500]),
            const SizedBox(height: 16),
            Text(
              s.noInternet,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              s.checkNetwork,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPost,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(s.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, int count, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}