import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:plantie/shared/styles/colors.dart';
import 'package:readmore/readmore.dart';

import '../../layout/cubit/cubit.dart';
import '../../models/post/post_model.dart';
import '../../models/user/user_model.dart';
import '../../modules/Community/comment_screen.dart';
import '../../modules/Community/cubit/cubit.dart';
import '../../modules/Community/image_carousel.dart';
import '../styles/icon_broken.dart';

Widget defaultButton({
  required VoidCallback function,
  required String text,
  IconData? icon,
  bool? setStyle,
}) {
  return ElevatedButton(
    onPressed: function,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              icon,
              size: 25,
              color: Colors.white,
            ),
          ),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget buildCard({
  required BuildContext context,
  required IconData icon,
  required String title,
  Widget? trailing,
  Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      color: plantieColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    ),
  );
}

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
  bool isUperCase = false,
  TextStyle? style, // Optional style parameter
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        isUperCase ? text.toUpperCase() : text,
        style: style ??
            const TextStyle(
              color: Color(0xFF00C853), // Default color
              fontWeight: FontWeight.bold,
              fontSize: 16, // Default size
            ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  IconData? prefixIcon,
  IconData? suffixIcon,
  required String? Function(String?) validate,
  Function(String)? onSubmit,
  Function(String)? onChanged,
  VoidCallback? onTap,
  bool obscureText = false,
  bool enabled = true,
  VoidCallback? onSuffexPressed,
}) =>
    TextFormField(
      keyboardType: type,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmit,
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffexPressed,
              )
            : null,
      ),
      validator: validate,
      enabled: enabled,
    );

Widget buildAvatar({
  required double radius,
  File? localImage,
  String? networkImage,
  String placeholderAsset = 'assets/images/user.png',
  VoidCallback? onEdit,
}) {
  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: Offset(0, 4), // Shadow position
            ),
          ],
        ),
        child: CircleAvatar(
          radius: radius,
          child: ClipOval(
            child: networkImage != null && networkImage.isNotEmpty
                ? FadeInImage.assetNetwork(
                    placeholder: placeholderAsset,
                    image: networkImage,
                    fit: BoxFit.cover,
                    width: radius * 2,
                    height: radius * 2,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset(placeholderAsset, fit: BoxFit.cover),
                  )
                : (localImage != null
                    ? Image.file(
                        localImage,
                        fit: BoxFit.cover,
                        width: radius * 2,
                        height: radius * 2,
                      )
                    : Image.asset(
                        placeholderAsset,
                        fit: BoxFit.cover,
                        width: radius * 2,
                        height: radius * 2,
                      )),
          ),
        ),
      ),
      if (onEdit != null)
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.grey[600],
            radius: radius * 0.32,
            child: IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
            ),
          ),
        ),
    ],
  );
}

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

void showToast({
  required String text,
  required ToastStates state,
  gravity = ToastGravity.BOTTOM,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { success, error, warning, info }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
    case ToastStates.info:
      color = Colors.amber;
      break;
  }

  return color;
}

Future<void> showCustomDialog({
  required BuildContext context,
  Color backgroundColor = Colors.white54,
  required String title,
  required String content,
  required String cancelText,
  required VoidCallback onCancel,
  required String confirmText,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(title),
      content: Text(
        content,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelText,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmText,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    ),
  );
}

Widget buildPostItem(PostModel post, context, index) {
  final cubit = CommunityCubit.get(context);
  final currentUserId = CurrentUser.user!.uId;

  return Card(
    color:
    AppCubit.get(context).isDark ? HexColor("1C1C1E") : HexColor("FFFFFF"),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: post.image ?? "",
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/user.png',
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.name,
                    ),
                    Text(
                      DateFormat('d MMM h:mm a').format(post.dateTime),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_horiz,
                  color: AppCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Post"),
                        content: const Text("Are you sure you want to delete this post?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              cubit.deletePost(post.postId);
                              Navigator.pop(context);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  if (post.uId == CurrentUser.user!.uId)
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete Post',
                       style: TextStyle(
                         fontSize: 18,
                       ),

                      ),
                    ),
                  const PopupMenuItem<String>(
                    value: 'share',
                    child: Text('Share Post',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // the separator (divider)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: AppCubit.get(context).isDark
                  ? Colors.grey[600]
                  : Colors.grey[300],
            ),
          ),
          // text post
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),

              child:ReadMoreText(
                post.text!,
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: plantieColor,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                style: Theme.of(context).textTheme.titleLarge,
                // moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
          ),

          // post images
          if (post.postImage != null && post.postImage!.isNotEmpty)
            ImageCarousel(imageUrls: post.postImage!),

          // likes count and comment count icons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Likes count on the left
                Row(
                  children: [
                    Icon(
                      post.likes!.contains(currentUserId)
                          ? Icons.thumb_up
                          : Icons.thumb_up_off_alt,
                      color: plantieColor,
                    ),
                    const SizedBox(width: 4),
                    Text(post.likes!.length.toString()),
                  ],
                ),

                // Comments count on the right
                Row(
                  children: [
                    Icon(IconBroken.Chat, color: plantieColor),
                    const SizedBox(width: 4),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(post.postId)
                          .collection('comments')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Text('0');
                        return Text(snapshot.data!.docs.length.toString());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Divider

          // Divider
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: AppCubit.get(context).isDark
                  ? Colors.grey[600]
                  : Colors.grey[300],
            ),
          ),

          // Last Row in the card
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: (CurrentUser.user!.image!.isNotEmpty)
                            ? NetworkImage(CurrentUser.user!.image!)
                            : AssetImage('assets/images/user.png'),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        'write a comment ...',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(postId: post.postId),
                      ),
                    );
                  },
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      post.likes!.contains(currentUserId)
                          ? Icons.thumb_up
                          : Icons.thumb_up_off_alt,
                      color: plantieColor,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'Like',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                onTap: () {
                  cubit.toggleLike(post.postId, currentUserId);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

