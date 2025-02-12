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

  PostSearchDelegate({required this.cubit, required this.theme});

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
    cubit.searchPosts(query);
    return _buildSearchResults();
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  Widget _buildSearchResults() {
    return BlocBuilder<CommunityCubit, CommunityStates>(
      builder: (context, state) {
        if (state is CommunitySearchResultsState) {
          if (state.results.isEmpty) {
            // Show "No posts" message if there are no results
            return Center(
              child: Text(
                S.of(context).no_posts,
                style: Theme.of(context).textTheme.titleLarge,
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            cubit.clearSearch();
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );
}
