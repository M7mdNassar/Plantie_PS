import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/modules/Community/cubit/cubit.dart';
import 'package:plantie/modules/Community/cubit/states.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = CommunityCubit.get(context);
    final currentUser = CurrentUser.user!;

    return BlocConsumer<CommunityCubit, CommunityStates>(
      listener: (context, state) {
        if (state is CreatePostSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(IconBroken.Arrow___Left_2),
            ),
            title: Text("Create Post"),
            actions: [
              defaultTextButton(
                function: () {
                  if (_textController.text.isNotEmpty || cubit.postImages.isNotEmpty) {
                    cubit.createPost(
                      text: _textController.text,
                      userId: currentUser.uId,
                      userName: currentUser.name,
                      userImage: currentUser.image,
                    );
                  }
                },
                text: "Post",
              ),
              SizedBox(width: 8),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is CreatePostLoadingState) LinearProgressIndicator(),
                if (state is CreatePostLoadingState) SizedBox(height: 10.0),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(CurrentUser.user!.image!),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Text(CurrentUser.user!.name),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "What is on your mind,",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: plantieColor),
                      ),
                    ),
                  ),
                ),
                if (cubit.postImages.isNotEmpty)
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.postImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                cubit.postImages[index],
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close, size: 16),
                                ),
                                onPressed: () => cubit.removePostImage(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 20),


                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => cubit.pickPostImages(),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(width: 5),
                            Text('Add Photos'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}