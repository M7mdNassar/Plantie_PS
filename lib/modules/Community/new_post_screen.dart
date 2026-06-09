import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/modules/Community/cubit/cubit.dart';
import 'package:plantie/modules/Community/cubit/states.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import 'package:plantie/shared/styles/colors.dart';
import '../../generated/l10n.dart';
import '../../shared/styles/icon_broken.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  late final TextEditingController _textController;
  CommunityCubit? _cubit;

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _cubit?.clearPostDraft();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = CommunityCubit.get(context);
    _cubit = cubit;
    final currentUser = CurrentUser.user;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            S.of(context).userDataNotFound,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return BlocConsumer<CommunityCubit, CommunityStates>(listener: (context, state) {
      if (state is CreatePostSuccessState) {
        showToast(text: S.of(context).postCreatedSuccessfully, state: ToastStates.success);
        Navigator.pop(context);
      } else if (state is CommunityErrorState) {
        if (state.error == "No internet connection. Please try again later.") {
          _showOfflineDialog(context);
        } else {
          showToast(text: state.error, state: ToastStates.error);
        }
      }
    },
      builder: (context, state) {
        final isLoading = state is CreatePostLoadingState;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: AppBar(
            leading: IconButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              icon: const Icon(IconBroken.Arrow___Left_2),
            ),
            titleSpacing: 0,
            title: Text(S.of(context).createPost),
            bottom: isLoading
                ? const PreferredSize(
              preferredSize: Size.fromHeight(2),
              child: LinearProgressIndicator(minHeight: 2),
            )
                : null,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildComposerCard(context, currentUser, isLoading),
                        if (cubit.postImages.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildPhotoStrip(context, cubit, isLoading),
                        ],
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(context, currentUser, cubit, isLoading),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComposerCard(
      BuildContext context,
      UserModel currentUser,
      bool isLoading,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: plantieColor.withValues(alpha: 0.14),
                backgroundImage:
                (currentUser.image != null && currentUser.image!.isNotEmpty)
                    ? NetworkImage(currentUser.image!)
                    : const AssetImage('assets/images/default_avatar.png')
                as ImageProvider,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _textController,
            enabled: !isLoading,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            minLines: 7,
            maxLines: 12,
            style:
            Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: S.of(context).whatsOnMind,
              hintStyle: TextStyle(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
              filled: true,
              fillColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              contentPadding: const EdgeInsets.all(18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: plantieColor, width: 1.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoStrip(
      BuildContext context, CommunityCubit cubit, bool isLoading) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library_outlined, size: 18, color: plantieColor),
              const SizedBox(width: 8),
              Text(
                S.of(context).photos,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '${cubit.postImages.length}/4',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: cubit.postImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final file = cubit.postImages[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.file(
                        file,
                        width: 132,
                        height: 132,
                        fit: BoxFit.cover,
                        cacheWidth: 720,
                        filterQuality: FilterQuality.low,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(999),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: isLoading
                                ? null
                                : () => cubit.removePostImage(index),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.close_rounded,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context,
      UserModel currentUser,
      CommunityCubit cubit,
      bool isLoading,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPost = _textController.text.trim().isNotEmpty || cubit.postImages.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : () => cubit.pickPostImages(),
                icon: const Icon(Icons.photo_library_outlined, size: 20),
                label: Text(S.of(context).addPhotos),
                style: OutlinedButton.styleFrom(
                  foregroundColor: plantieColor,
                  side: BorderSide(color: plantieColor.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: (!canPost || isLoading) ? null : () {
                  cubit.createPost(text: _textController.text);
                },
                icon: isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(S.of(context).postButton),
                style: FilledButton.styleFrom(
                  backgroundColor: plantieColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void _showOfflineDialog(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(S.of(ctx).noInternetConnection),
        ],
      ),
      content: Text(S.of(ctx).offlinePostMessage),
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(S.of(ctx).cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            // Optionally retry? Or just close.
          },
          child: Text(S.of(ctx).ok),
        ),
      ],
    ),
  );
}