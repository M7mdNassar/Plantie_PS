import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantie/models/post/post_model.dart';
import '../../models/user/user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';

class CommentScreen extends StatelessWidget {
  final String postId;
  final TextEditingController _commentController = TextEditingController();

  CommentScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final cubit = CommunityCubit.get(context);
    final currentUser = CurrentUser.user!;

    return Scaffold(
      appBar: AppBar(title: const Text("Comments")),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('posts')
                .doc(postId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final post = PostModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>,
                  id: snapshot.data!.id);
              return buildPostItem(post, context, 0); // Reuse post item UI
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final comment = CommentModel.fromJson(
                        snapshot.data!.docs[index].data() as Map<String, dynamic>);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(comment.userImage ?? ''),
                      ),
                      title: Text(comment.userName),
                      subtitle: Text(comment.text),
                      trailing: Text(
                        DateFormat('MMM dd, HH:mm')
                            .format(comment.timestamp),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(IconBroken.Send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      cubit.addComment(
                        postId: postId,
                        text: _commentController.text,
                        userId: currentUser.uId,
                        userName: currentUser.name,
                        userImage: currentUser.image,
                      );
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}