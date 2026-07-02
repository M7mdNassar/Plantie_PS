import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plantie/config/app_config.dart';
import 'package:plantie/config/config_manager.dart';
import 'package:plantie/modules/Community/cubit/cubit.dart';
import 'package:plantie/modules/Community/cubit/states.dart';
import 'package:plantie/modules/Community/new_post_screen.dart';
import 'package:plantie/modules/Community/post_search.dart';
import 'package:plantie/modules/Community/shimmer_post_skeleton.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/responsive_text.dart';
import '../../generated/l10n.dart';
import '../../shared/styles/app_colors.dart';
import '../../shared/styles/icon_broken.dart';
import '../../shared/network/local/social_upload_service.dart';
import '../../shared/network/remote/supabase_auth_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final ValueNotifier<bool> _showCreatePostButton = ValueNotifier<bool>(true);
  int _lastPrefetchedPostCount = 0;
  bool _isFiltering = false;

  // Config check state (only for the posts area)
  bool _isCheckingConfig = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = CommunityCubit.get(context);
      if (cubit.posts.isEmpty) {
        cubit.getPosts(); // will load cached or fetch
      }
      _checkCommunityConfig();
    });
  }

  // ---------------------- Community config check (non‑blocking) ----------------------
  Future<void> _checkCommunityConfig() async {
    setState(() => _isCheckingConfig = true);
    await ConfigManager().fetchIfNeeded(force: true);
    setState(() => _isCheckingConfig = false);
  }

  void _setCreatePostButtonVisible(bool visible) {
    if (_showCreatePostButton.value == visible) return;
    _showCreatePostButton.value = visible;
  }

  // ---------------------- Feed Sort Bar (Filters ALWAYS enabled) ----------------------
  PreferredSizeWidget _buildFeedSortBar(
      BuildContext context,
      CommunityCubit cubit,
      bool isDark,
      ) {
    final s = S.of(context);
    final sortOptions = {
      'latest': s.latest,
      'popular': s.popular,
      'trending': s.trending,
    };

    return PreferredSize(
      preferredSize: const Size.fromHeight(58),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? HexColor("1C1C1E") : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDark ? HexColor("2C2C2E") : Colors.grey[100]!,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveText.padding(context, 12),
          vertical: ResponsiveText.padding(context, 8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? HexColor("272729") : Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.filter_list_rounded,
                  size: 16,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 10),
              ...sortOptions.entries.map((entry) {
                final isSelected = cubit.feedSort == entry.key;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    // ✅ ALWAYS enabled – the cubit handles offline check
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _isFiltering = true);
                        cubit.setSortFilter(entry.key);
                      }
                    },
                    backgroundColor: isDark ? HexColor("272729") : Colors.grey[50],
                    selectedColor: AppColors.primary.withOpacity(0.12),
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? Colors.white60 : Colors.grey[700]),
                      fontSize: 13,
                      letterSpacing: -0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.5)
                          : Colors.transparent,
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPosts() async {
    final cubit = CommunityCubit.get(context);
    _lastPrefetchedPostCount = 0;
    // Re‑check config, then refresh posts
    await _checkCommunityConfig();
    await cubit.getPosts(refresh: true);
  }

  @override
  void dispose() {
    _showCreatePostButton.dispose();
    super.dispose();
  }

  void _prefetchUpcomingImages(BuildContext context, CommunityCubit cubit) {
    final posts = cubit.posts;
    if (posts.length < _lastPrefetchedPostCount) {
      _lastPrefetchedPostCount = 0;
    }
    if (posts.length <= _lastPrefetchedPostCount) return;

    final newPosts = posts.sublist(_lastPrefetchedPostCount);
    _lastPrefetchedPostCount = posts.length;

    final urls = <String>[];
    for (final post in newPosts.take(3)) {
      final images = post.postImage ?? const <String>[];
      for (final url in images) {
        if (url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'))) {
          urls.add(url);
        }
      }
    }

    if (urls.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final url in urls.take(6)) {
        try {
          precacheImage(CachedNetworkImageProvider(url), context);
        } catch (e) {
          debugPrint('Failed to precache image: $e');
        }
      }
    });
  }

  void _showOfflineRetryDialog(BuildContext context, VoidCallback onRetry) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(S.of(ctx).noInternetConnection),
          ],
        ),
        content: Text(S.of(ctx).offlinePostMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRetry();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(S.of(ctx).retry),
          ),
        ],
      ),
    );
  }

  void _showOfflineMessage(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(S.of(ctx).noInternetConnection),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx).ok),
          ),
        ],
      ),
    );
  }

  // ---------------------- BUILD ----------------------
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityCubit, CommunityStates>(
      listener: (context, state) {
        if (state is CommunityPostsLoadedState) {
          setState(() => _isFiltering = false);
          _prefetchUpcomingImages(context, CommunityCubit.get(context));
        }
        if (state is CommunityLoadingMoreState) {
          _prefetchUpcomingImages(context, CommunityCubit.get(context));
        }

        if (state is CommunityOfflineState) {
          setState(() => _isFiltering = false);
        }

        if (state is CommunityErrorState) {
          final cubit = CommunityCubit.get(context);
          setState(() => _isFiltering = false);

          if (state.error == 'offline_like') {
            _showOfflineMessage(context, S.of(context).offlineLikeMessage);
            return;
          }
          if (state.error == 'offline_queued') {
            _showOfflineMessage(context, S.of(context).offlinePostMessage);
            return;
          }

          if (state.error == 'offline_filter') {
            _showOfflineRetryDialog(context, () {
              cubit.setSortFilter(cubit.feedSort);
            });
            return;
          }

          if (cubit.posts.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        }
      },
      builder: (context, state) {
        final cubit = CommunityCubit.get(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final s = S.of(context);
        final posts = cubit.posts;
        final hasPosts = posts.isNotEmpty;

        return Scaffold(
          backgroundColor: isDark ? HexColor("0F0F0F") : Colors.grey[50],
          floatingActionButton: _buildFloatingActionButton(context, cubit),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is UserScrollNotification) {
                if (scrollNotification.direction == ScrollDirection.reverse) {
                  _setCreatePostButtonVisible(false);
                } else if (scrollNotification.direction == ScrollDirection.forward) {
                  _setCreatePostButtonVisible(true);
                } else if (scrollNotification.metrics.pixels <=
                    scrollNotification.metrics.minScrollExtent) {
                  _setCreatePostButtonVisible(true);
                }
              }

              if (scrollNotification.metrics.pixels >=
                  scrollNotification.metrics.maxScrollExtent * 0.8) {
                if (cubit.hasMore() && !cubit.isFetchingMore) {
                  cubit.loadMorePosts();
                }
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              color: AppColors.primary,
              backgroundColor: isDark ? HexColor('1C1C1E') : Colors.white,
              edgeOffset: 120,
              child: Stack(
                children: [
                  CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    slivers: [
                      _buildSliverAppBar(context, cubit, isDark),

                      // ---------------------- POSTS AREA (new priority logic) ----------------------
                      // Priority 1: Still checking config -> show loading
                      if (_isCheckingConfig)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      // Priority 2: Config exists and community is disabled -> show unavailable
                      else if (ConfigManager().hasCachedConfig &&
                          !AppConfig.isCommunityEnabled)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildCommunityUnavailable(context),
                        )
                      // Priority 3: We have posts -> show them
                      else if (hasPosts)
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveText.padding(context, 12),
                              vertical: ResponsiveText.padding(context, 14),
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: ResponsiveText.padding(
                                            context, 14)),
                                    child: buildPostItem(posts[index], context, index),
                                  );
                                },
                                childCount: posts.length,
                              ),
                            ),
                          )
                        // Priority 4: No posts -> show appropriate placeholder based on state
                        else if (state is CommunityOfflineState)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildOfflineState(context),
                            )
                          else if (state is CommunityErrorState)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: _buildErrorState(context, state, cubit),
                              )
                            else if (state is CommunityLoadingState ||
                                  state is CommunityInitialState)
                                const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: ShimmerPostSkeleton(),
                                )
                              else if (state is CommunityEmptyState)
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: _buildEmptyState(context),
                                  )
                                else
                                // Fallback: show empty state
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: _buildEmptyState(context),
                                  ),
                    ],
                  ),
                  // Sync Status Banner (unchanged)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ValueListenableBuilder<int>(
                      valueListenable: socialUploadService.pendingCount,
                      builder: (context, count, _) {
                        if (count == 0) return const SizedBox.shrink();
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Colors.orange[100],
                          child: Row(
                            children: [
                              const Icon(Icons.cloud_upload_rounded,
                                  color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      S.of(context).pendingUploadsTitle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      S.of(context).pendingUploadsMessage(count),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FutureBuilder<bool>(
                                future: SupabaseAuthService().isConnectedFast(),
                                builder: (context, snapshot) {
                                  final isOnline = snapshot.data ?? false;
                                  return TextButton(
                                    onPressed: isOnline
                                        ? () => socialUploadService.attemptPendingUploads()
                                        : null,
                                    child: Text(
                                      isOnline
                                          ? S.of(context).syncNow
                                          : S.of(context).offlineSyncWait,
                                      style: TextStyle(
                                        color: isOnline ? Colors.orange : Colors.grey[500],
                                        fontWeight: isOnline ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (state is CommunityLoadingMoreState)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? HexColor('1C1C1E') : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  AlwaysStoppedAnimation(AppColors.primary),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                s.loadingMorePosts,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
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
        );
      },
    );
  }

  // ---------------------- Posts area placeholder widgets ----------------------
  Widget _buildCommunityUnavailable(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              s.community_unavailable_title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              s.community_unavailable_subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshPosts,
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

  // ---------------------- SLIVER APP BAR (unchanged) ----------------------
  Widget _buildSliverAppBar(
      BuildContext context, CommunityCubit cubit, bool isDark) {
    final s = S.of(context);
    return SliverAppBar(
      toolbarHeight: 72,
      centerTitle: false,
      backgroundColor: isDark ? HexColor("1C1C1E") : Colors.white,
      elevation: 0,
      titleSpacing: 16,
      floating: true,
      snap: true,
      pinned: false,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(1.0),
                  AppColors.primary.withOpacity(0.6),
                ],
              ),
            ),
            child: const Icon(
              Icons.forum_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            s.community,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ResponsiveText.title(context) + 2,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Semantics(
            button: true,
            enabled: true,
            label: s.searchPosts,
            onTap: () => _showSearch(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? HexColor("272729") : Colors.grey[100],
              ),
              child: IconButton(
                onPressed: () => _showSearch(context),
                iconSize: 20,
                icon: Icon(
                  IconBroken.Search,
                  color: isDark ? Colors.white70 : Colors.grey[800],
                ),
                tooltip: s.searchPosts,
              ),
            ),
          ),
        ),
      ],
      bottom: _buildFeedSortBar(context, cubit, isDark),
    );
  }

  // ---------------------- FLOATING ACTION BUTTON (unchanged) ----------------------
  Widget _buildFloatingActionButton(
      BuildContext context, CommunityCubit cubit) {
    final s = S.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: _showCreatePostButton,
      builder: (context, isVisible, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 92),
          child: AnimatedScale(
            scale: isVisible ? 1 : 0.92,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutBack,
            child: AnimatedSlide(
              offset: isVisible ? Offset.zero : const Offset(1.15, 0.25),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: isVisible ? 1 : 0,
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                child: IgnorePointer(
                  ignoring: !isVisible,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      child: Semantics(
        button: true,
        enabled: true,
        label: s.createNewPost,
        onTap: () => _navigateToNewPost(context, cubit),
        child: FloatingActionButton.extended(
          heroTag: "addPost",
          backgroundColor: AppColors.primary,
          elevation: 6,
          splashColor: AppColors.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () => _navigateToNewPost(context, cubit),
          tooltip: s.createNewPost,
          icon: const Icon(
            IconBroken.Paper_Upload,
            size: 20,
            color: Colors.white,
          ),
          label: Text(
            s.post,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToNewPost(BuildContext context, CommunityCubit cubit) {
    navigateTo(
      context,
      BlocProvider.value(
        value: cubit,
        child: const NewPostScreen(),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    showSearch(
      context: context,
      delegate: PostSearchDelegate(
        cubit: CommunityCubit.get(context),
        theme: theme,
        searchFieldLabelText: s.searchPosts,
        searchByContentText: s.searchByPostContent,
        noMatchText: s.noPostsMatch,
        clearSearchTooltip: s.clearSearch,
      ),
    );
  }

  // ---------------------- POSTS LIST STATE WIDGETS (unchanged) ----------------------
  Widget _buildEmptyState(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveText.padding(context, 32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.14),
                    AppColors.primary.withOpacity(0.02),
                  ],
                ),
              ),
              child: Icon(Icons.inbox_rounded, size: 52, color: AppColors.primary),
            ),
            SizedBox(height: ResponsiveText.padding(context, 24)),
            Text(
              s.no_posts,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveText.headline(context),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveText.padding(context, 8)),
            Text(
              s.beFirstToShare,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[500],
                fontSize: ResponsiveText.body(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
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
        padding: EdgeInsets.symmetric(horizontal: ResponsiveText.padding(context, 32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? HexColor("272729") : Colors.grey[100],
              ),
              child: Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey[500]),
            ),
            SizedBox(height: ResponsiveText.padding(context, 24)),
            Text(
              s.noInternet,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveText.headline(context),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveText.padding(context, 8)),
            Text(
              s.checkNetwork,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[500],
                fontSize: ResponsiveText.body(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveText.padding(context, 20)),
            ElevatedButton.icon(
              onPressed: _refreshPosts,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(s.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, CommunityErrorState state, CommunityCubit cubit) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveText.padding(context, 32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? HexColor("272729") : Colors.grey[100],
              ),
              child: Icon(Icons.error_outline, size: 48, color: Colors.red),
            ),
            SizedBox(height: ResponsiveText.padding(context, 24)),
            Text(
              s.errorLoadingPosts,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveText.headline(context),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveText.padding(context, 8)),
            Text(
              state.error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[500],
                fontSize: ResponsiveText.body(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveText.padding(context, 20)),
            ElevatedButton.icon(
              onPressed: () => cubit.getPosts(refresh: true),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(s.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}