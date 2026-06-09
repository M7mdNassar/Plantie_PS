import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/shared/styles/colors.dart';
import '../../generated/l10n.dart';
import '../../shared/components/components.dart';
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
          color: plantieColor,
        ),
        titleSpacing: 5,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Only search if query is not empty
    if (query.isNotEmpty) {
      cubit.searchPosts(query);
      return _buildSearchResults(context);
    }

    // Show helpful message when search is empty
    return _buildEmptySearchState(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    // Only search if query is not empty
    if (query.isNotEmpty) {
      cubit.searchPosts(query);
      return _buildSearchResults(context);
    }

    // Show helpful message when search is empty
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
        if (state is CommunitySearchResultsState) {
          if (state.results.isEmpty) {
            // Show "No posts" message if there are no results
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: plantieColor.withValues(alpha: 0.5),
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
            // Show the list of posts
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
        // Show loading only during actual search
        return const Center(child: CircularProgressIndicator());
      },
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
