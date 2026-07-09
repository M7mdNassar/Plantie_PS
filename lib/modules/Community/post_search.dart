import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../generated/l10n.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/app_colors.dart';
import '../../shared/network/remote/supabase_auth_service.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class PostSearchDelegate extends SearchDelegate {
  final CommunityCubit cubit;
  final ThemeData theme;
  final String searchFieldLabelText;
  final String searchByContentText;
  final String noMatchText;
  final String clearSearchTooltip;

  PostSearchDelegate({
    required this.cubit,
    required this.theme,
    required this.searchFieldLabelText,
    required this.searchByContentText,
    required this.noMatchText,
    required this.clearSearchTooltip,
  });

  @override
  String? get searchFieldLabel => searchFieldLabelText;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        iconTheme: theme.iconTheme.copyWith(
          color: AppColors.primary,
        ),
        titleSpacing: 5,
        backgroundColor: theme.appBarTheme.backgroundColor,
        // ✅ Add bottom padding to move search field down
        toolbarHeight: 80,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return _buildSearchResults(context);
    }
    return _buildEmptySearchState(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      return _buildSearchResults(context);
    }
    return _buildEmptySearchState(context);
  }

  Widget _buildEmptySearchState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).searchPosts,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              searchByContentText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityStates>(
      builder: (context, state) {
        // ✅ Check connectivity before searching
        return FutureBuilder<bool>(
          future: SupabaseAuthService().isConnectedFast(),
          builder: (context, snapshot) {
            final hasInternet = snapshot.data ?? false;

            // ✅ If offline, show the offline state immediately
            if (!hasInternet && !snapshot.hasData) {
              // Still checking – show loading briefly
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildOfflineState(context);
            }

            if (!hasInternet) {
              return _buildOfflineState(context);
            }

            // Online – perform search
            if (query.isNotEmpty) {
              cubit.searchPosts(query);
            }

            if (state is CommunitySearchResultsState) {
              if (state.results.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).no_posts,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          noMatchText,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (context, index) => buildPostItem(
                    state.results[index],
                    context,
                    index,
                  ),
                );
              }
            }

            // ✅ Show loading only when actually searching (and online)
            if (query.isNotEmpty && snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show empty state when query is empty
            return _buildEmptySearchState(context);
          },
        );
      },
    );
  }

  Widget _buildOfflineState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = S.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
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

  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
          cubit.clearSearch();
        },
        tooltip: clearSearchTooltip,
      ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );
}