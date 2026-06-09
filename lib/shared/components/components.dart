import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:plantie/shared/styles/colors.dart';
import 'package:readmore/readmore.dart';
import '../../generated/l10n.dart';
import '../../layout/cubit/cubit.dart';
import '../../models/post/post_model.dart';
import '../../models/user/user_model.dart';
import '../../modules/Community/comment_screen.dart';
import '../../modules/Community/cubit/cubit.dart';
import '../../modules/Community/image_carousel.dart';
import '../styles/icon_broken.dart';
import '../services/notification_service.dart';


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
  TextStyle? style,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        isUperCase ? text.toUpperCase() : text,
        style: style ??
            const TextStyle(
              color: Color(0xFF00C853),
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
  String placeholderAsset = 'assets/images/default_avatar.png',
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey[200],
          child: ClipOval(
            child: localImage != null
                ? Image.file(localImage, fit: BoxFit.cover, width: radius * 2, height: radius * 2)
                : (networkImage != null && networkImage.isNotEmpty)
                ? CachedNetworkImage(
              imageUrl: networkImage,
              fit: BoxFit.cover,
              width: radius * 2,
              height: radius * 2,
              placeholder: (context, url) => Image.asset(placeholderAsset, fit: BoxFit.cover),
              errorWidget: (context, url, error) => Image.asset(placeholderAsset, fit: BoxFit.cover),
            )
                : Image.asset(placeholderAsset, fit: BoxFit.cover),
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
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
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
      (route) => false,
);

void showToast({
  required String text,
  required ToastStates state,
}) {
  final type = _mapToastStateToNotificationType(state);
  const title = 'Notification'; // Or use S.current.notification if needed
  NotificationService.show(
    title: title,
    message: text,
    type: type,
  );
}

enum ToastStates { success, error, warning, info }

Color chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return Colors.green;
    case ToastStates.error:
      return Colors.red;
    case ToastStates.warning:
      return Colors.amber;
    case ToastStates.info:
      return Colors.amber;
  }
}

NotificationType _mapToastStateToNotificationType(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return NotificationType.success;
    case ToastStates.error:
      return NotificationType.error;
    case ToastStates.warning:
      return NotificationType.warning;
    case ToastStates.info:
      return NotificationType.info;
  }
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

// Helper to safely get author name
String _getAuthorName(PostModel post) {
  return post.author?.name ?? 'User';
}

// Helper to safely get author image
String _getAuthorImage(PostModel post) {
  return post.author?.image ?? '';
}

Widget buildPostItem(PostModel post, BuildContext context, int index) {
  final cubit = CommunityCubit.get(context);
  final currentUserId = CurrentUser.user.id;
  final isDark = AppCubit.get(context).isDark;
  final isLiked = post.userLiked;
  final isOwner = post.uId == currentUserId;

  return Semantics(
    container: true,
    label: '${S.of(context).postedBy} ${_getAuthorName(post)}',
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: isDark ? HexColor("1C1C1E") : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey[300]!)
                .withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(context, post, cubit, isDark, isOwner),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (isDark ? Colors.white : Colors.black).withValues(alpha: 0),
                      (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                      (isDark ? Colors.white : Colors.black).withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReadMoreText(
                post.text ?? '',
                trimMode: TrimMode.Line,
                trimLines: 3,
                colorClickableText: plantieColor,
                trimCollapsedText: S.of(context).showMore,
                trimExpandedText: S.of(context).showLess,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  fontSize: 15,
                ),
                moreStyle: TextStyle(
                  color: plantieColor,
                  fontWeight: FontWeight.w600,
                ),
                lessStyle: TextStyle(
                  color: plantieColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (post.postImage != null && post.postImage!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: ImageCarousel(imageUrls: post.postImage!),
              ),
            ],
            _buildEngagementStats(context, post, isDark),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Container(
                height: 1,
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
              ),
            ),
            _buildPostActions(context, post, cubit, isLiked, isDark),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPostHeader(
    BuildContext context,
    PostModel post,
    CommunityCubit cubit,
    bool isDark,
    bool isOwner,
    ) {
  final authorName = _getAuthorName(post);
  final authorImage = _getAuthorImage(post);

  return SizedBox(
    height: 58,
    child: Row(
      children: [
        Semantics(
          image: true,
          label: '${authorName} ${S.of(context).avatar}',
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  plantieColor.withValues(alpha: 0.95),
                  plantieColor.withValues(alpha: 0.35),
                ],
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: authorImage,
                width: 46,
                height: 46,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: plantieColor.withValues(alpha: 0.1),
                  child: const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/default_avatar.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: isDark ? Colors.white : Colors.black,
                ),
                semanticsLabel: '${S.of(context).postedBy} $authorName',
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat.yMMMMEEEEd(
                  Localizations.localeOf(context).toString(),
                ).add_jm().format(post.dateTime),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (isOwner)
          Semantics(
            button: true,
            enabled: true,
            label: S.of(context).moreOptions,
            onTap: () => _showPostMenu(context, post, cubit),
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_horiz,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              tooltip: S.of(context).postOptions,
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(context, post, cubit);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline, size: 20),
                      const SizedBox(width: 12),
                      Text(S.of(context).deletePost),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

Widget _buildEngagementStats(
    BuildContext context,
    PostModel post,
    bool isDark,
    ) {
  return Padding(
    padding: const EdgeInsets.only(top: 2, bottom: 8),
    child: Row(
      children: [
        Semantics(
          label: '${post.likeCount} ${S.of(context).likes}',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white10
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.thumb_up_off_alt,
                  size: 13,
                  color: plantieColor,
                ),
                const SizedBox(width: 6),
                Text(
                  post.likeCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[200] : Colors.grey[800],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Semantics(
          label: S.of(context).comments,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white10
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  IconBroken.Chat,
                  size: 13,
                  color: plantieColor,
                ),
                const SizedBox(width: 6),
                Text(
                  post.commentCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[200] : Colors.grey[800],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPostActions(
    BuildContext context,
    PostModel post,
    CommunityCubit cubit,
    bool isLiked,
    bool isDark,
    ) {
  return Semantics(
    container: true,
    label: S.of(context).postActions,
    child: Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            enabled: true,
            label: S.of(context).writeComment,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentScreen(postId: post.postId),
                ),
              );
            },
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(postId: post.postId),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(999),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white10
                      : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconBroken.Chat,
                      size: 17,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).comment,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.grey[100] : Colors.grey[900],
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Semantics(
            button: true,
            enabled: true,
            label: isLiked ? S.of(context).unlikePost : S.of(context).likePost,
            onTap: () => cubit.toggleLike(post.postId),
            child: InkWell(
              onTap: () => cubit.toggleLike(post.postId),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                decoration: BoxDecoration(
                  color: isLiked
                      ? plantieColor.withValues(alpha: 0.12)
                      : (isDark
                      ? Colors.white10
                      : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                      size: 17,
                      color: isLiked
                          ? plantieColor
                          : (isDark ? Colors.grey[300] : Colors.grey[700]),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).like,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isLiked
                            ? plantieColor
                            : (isDark ? Colors.grey[100] : Colors.grey[900]),
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void _showPostMenu(BuildContext context, PostModel post, CommunityCubit cubit) {
  // optional
}

void _showDeleteConfirmation(
    BuildContext context,
    PostModel post,
    CommunityCubit cubit,
    ) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        S.of(context).deletePostQuestion,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      content: Text(S.of(context).deletePostConfirmation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(
            S.of(context).cancel,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            cubit.deletePost(post);
            Navigator.pop(dialogContext);
          },
          child: Text(
            S.of(context).delete,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

}