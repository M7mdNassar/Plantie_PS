import 'package:flutter/material.dart';
import 'package:plantie/models/post/post_model.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../generated/l10n.dart';
import '../../shared/network/remote/supabase_service.dart';
import '../../shared/components/components.dart';
import '../../shared/network/remote/supabase_auth_service.dart';
import '../Community/post_detail_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String? userName;

  const UserProfileScreen({
    super.key,
    required this.userId,
    this.userName,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;
  bool _isLoading = true;
  bool _isOffline = false;
  bool _isFollowLoading = false;
  UserModel? _user;
  List<PostModel> _userPosts = [];
  bool _isOwnProfile = false;
  int _followersCount = 0;
  int _followingCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
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
      final currentUser = CurrentUser.user;
      _isOwnProfile = currentUser.id == widget.userId;

      final user = await _fetchUser(widget.userId);
      if (user != null) {
        setState(() => _user = user);
      }

      final posts = await _fetchUserPosts(widget.userId);
      setState(() => _userPosts = posts);

      final followers = await supabaseService.getFollowersCount(widget.userId);
      final following = await supabaseService.getFollowingCount(widget.userId);
      setState(() {
        _followersCount = followers;
        _followingCount = following;
      });

      if (!_isOwnProfile) {
        final follows = await supabaseService.isFollowing(
          currentUser.id,
          widget.userId,
        );
        setState(() => _isFollowing = follows);
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      if (e.toString().toLowerCase().contains('offline') ||
          e.toString().toLowerCase().contains('socketexception')) {
        setState(() => _isOffline = true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<UserModel?> _fetchUser(String userId) async {
    try {
      final response = await supabaseService.client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching user: $e');
      return null;
    }
  }

  Future<List<PostModel>> _fetchUserPosts(String userId) async {
    try {
      final response = await supabaseService.client
          .from('posts')
          .select('*, users(*), post_images(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final posts = response.map((json) => PostModel.fromJson(json)).toList();
      final currentUserId = CurrentUser.user.id;
      if (currentUserId.isNotEmpty) {
        final postIds = posts.map((p) => p.postId).toList();
        if (postIds.isNotEmpty) {
          final likesResponse = await supabaseService.client
              .from('post_likes')
              .select('post_id')
              .eq('user_id', currentUserId)
              .inFilter('post_id', postIds);
          final likedPostIds = likesResponse.map((like) => like['post_id'] as String).toSet();
          for (int i = 0; i < posts.length; i++) {
            posts[i] = posts[i].copyWith(userLiked: likedPostIds.contains(posts[i].postId));
          }
        }
      }
      return posts;
    } catch (e) {
      debugPrint('Error fetching user posts: $e');
      return [];
    }
  }

  Future<void> _toggleFollow() async {
    if (_isFollowLoading) return;
    setState(() => _isFollowLoading = true);

    final currentUser = CurrentUser.user;
    try {
      if (_isFollowing) {
        await supabaseService.unfollowUser(currentUser.id, widget.userId);
        setState(() {
          _isFollowing = false;
          _followersCount--;
        });
      } else {
        await supabaseService.followUser(currentUser.id, widget.userId);
        setState(() {
          _isFollowing = true;
          _followersCount++;
        });
      }
    } catch (e) {
      debugPrint('Error toggling follow: $e');
    } finally {
      setState(() => _isFollowLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = S.of(context);

    if (_isOffline) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          title: Text(widget.userName ?? s.profile),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: _buildOfflineState(context),
      );
    }

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.userName ?? s.profile),
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.userName ?? s.profile),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off_rounded, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                s.userNotFound,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(_user!.name),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          _buildProfileHeader(context, isDark),
          const SizedBox(height: 8),
          _buildStatsRow(context, isDark),
          TabBar(
            controller: _tabController,
            labelColor: isDark ? Colors.white : AppColors.primary,
            unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[600],
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: s.posts),
              Tab(text: s.about),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPostsTab(context, isDark),
                _buildAboutTab(context, isDark),
              ],
            ),
          ),
        ],
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
              onPressed: _loadUserProfile,
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

  Widget _buildProfileHeader(BuildContext context, bool isDark) {
    final s = S.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: (_user!.image != null && _user!.image!.isNotEmpty)
                  ? CachedNetworkImage(
                imageUrl: _user!.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              )
                  : const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user!.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (_user!.bio != null && _user!.bio!.isNotEmpty)
                  Text(
                    _user!.bio!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                if (!_isOwnProfile)
                  ElevatedButton(
                    onPressed: _isFollowLoading ? null : _toggleFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFollowing
                          ? (isDark ? Colors.grey[700] : Colors.grey[300])
                          : AppColors.primary,
                      foregroundColor: _isFollowing
                          ? (isDark ? Colors.white : Colors.black87)
                          : Colors.white,
                      minimumSize: const Size(100, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isFollowLoading
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      _isFollowing ? s.unfollow : s.follow,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDark) {
    final s = S.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, _userPosts.length.toString(), s.posts, isDark),
          _buildStatItem(context, _followersCount.toString(), s.followers, isDark),
          _buildStatItem(context, _followingCount.toString(), s.following, isDark),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String count, String label, bool isDark) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPostsTab(BuildContext context, bool isDark) {
    final s = S.of(context);

    if (_userPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _isOwnProfile
                  ? s.noPostsYet
                  : '${_user!.name} ${s.hasNoPosts}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: _userPosts.length,
      itemBuilder: (context, index) {
        final post = _userPosts[index];
        return GestureDetector(
          onTap: () {
            navigateTo(
              context,
              PostDetailScreen(postId: post.postId),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: post.postImage != null && post.postImage!.isNotEmpty
                  ? DecorationImage(
                image: CachedNetworkImageProvider(post.postImage!.first),
                fit: BoxFit.cover,
              )
                  : null,
              color: Colors.grey[300],
            ),
            child: post.postImage == null || post.postImage!.isEmpty
                ? Center(
              child: Icon(
                Icons.text_fields,
                color: Colors.grey[500],
              ),
            )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildAboutTab(BuildContext context, bool isDark) {
    final s = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_user!.bio != null && _user!.bio!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black12 : Colors.grey[100]!,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.about,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _user!.bio!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          if (_user!.createdAt != null)
            _buildInfoTile(context, s.joinDate, _formatDate(_user!.createdAt!), isDark),
          if (_user!.country != null && _user!.country!.isNotEmpty)
            _buildInfoTile(context, s.country, _user!.country!, isDark),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}