
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Community/cubit/cubit.dart';
import 'package:plantie/modules/Community/cubit/states.dart';
import 'package:plantie/modules/Community/new_post_screen.dart';
import 'package:plantie/modules/Community/post_search.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';


class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityCubit, CommunityStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CommunityCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text("Community"),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      IconBroken.Notification,
                    )),
                IconButton(onPressed: () => _showSearch(context),
                icon: Icon(IconBroken.Search)),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: "addPost",
              shape: CircleBorder(),
              onPressed: () {
                navigateTo(context, BlocProvider.value(
                  value: BlocProvider.of<CommunityCubit>(context),
                  child: NewPostScreen(),
                ),);
              },
              backgroundColor: plantieColor,
              child: Icon(
                IconBroken.Paper_Upload,
                size: 34,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
                  cubit.loadMorePosts();
                }
                return true;
              },
              child: ConditionalBuilder(
                condition: cubit.posts.isNotEmpty,
                builder: (context) =>
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index < cubit.posts.length) {
                                return buildPostItem(
                                    cubit.posts[index], context, index);
                              } else if (cubit.hasMore()) {
                                // Show loading indicator at the bottom if there are more posts to load
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                // No more posts to load
                                return const SizedBox.shrink();
                              }
                            },
                            separatorBuilder: (context,
                                index) => const SizedBox(height: 10),
                            itemCount: cubit.posts.length +
                                (cubit.hasMore() ? 1 : 0),
                          ),
                        ],
                      ),
                    ),
                fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: PostSearchDelegate(cubit: CommunityCubit.get(context)),
    );
  }
}