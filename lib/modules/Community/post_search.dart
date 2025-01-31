import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class PostSearchDelegate extends SearchDelegate {
  final CommunityCubit cubit;

  PostSearchDelegate({required this.cubit});

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
          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) => buildPostItem(
              state.results[index],
              context,
              index,
            ),
          );
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