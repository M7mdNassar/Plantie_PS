import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Home/cubit/cubit.dart';
import 'package:plantie/modules/Home/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit , HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Center(
              child: Text(
                "Home",
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
            );
          }),
    );
  }
}
