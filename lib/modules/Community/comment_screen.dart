import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantie/models/post/post_model.dart';
import 'package:plantie/shared/components/components.dart';
import '../../models/user/user_model.dart';
import '../../shared/styles/colors.dart';
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
                        backgroundImage: (comment.userImage != null && comment.userImage!.isNotEmpty)
                            ? NetworkImage(comment.userImage!)
                            : const AssetImage('assets/images/user.png'),
                      ),
                      title: Text(comment.userName,
                        style: Theme.of(context).textTheme.titleMedium,

                      ),
                      subtitle: Text(comment.text,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      trailing: Text(
                        DateFormat('MMM dd, HH:mm')
                            .format(comment.timestamp),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          height: 1.4,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(

              children: [
                Expanded(
                  child: TextField(
                    style: Theme.of(context).textTheme.titleMedium,
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon:  Icon(IconBroken.Send , color: plantieColor,),
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