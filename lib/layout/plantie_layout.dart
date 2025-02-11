import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plantie/shared/styles/icon_broken.dart';
import '../generated/l10n.dart';
import '../shared/styles/colors.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is FloatActionButtonPressed){
          AppCubit.get(context).changeIndex(2);
        }


        // i need handle verification email to use community (later)


      },
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return Scaffold(
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: _buildCameraFAB(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomNavBar(cubit, context),
        );
      },
    );
  }

  Widget _buildCameraFAB(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => AppCubit.get(context).startClassification(context),
      backgroundColor: plantieColor,
      child: const Icon(
        size: 34,
        IconBroken.Camera,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBottomNavBar(AppCubit cubit, BuildContext context) {

    final titles = [
      S.of(context).home,
      S.of(context).community,
      S.of(context).detection,
      S.of(context).profile2,
    ];

    return AnimatedBottomNavigationBar.builder(
      backgroundColor: cubit.isDark ? HexColor('333739') : Colors.white,
      itemCount: cubit.iconList.length,
      tabBuilder: (int index, bool isActive) {
        final color = isActive
            ? plantieColor
            : (cubit.isDark ? Colors.white54 : Colors.black54);
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cubit.iconList[index], size: 24, color: color),
            Text(
              titles[index],
              style: TextStyle(color: color, fontSize: 14),
            ),
          ],
        );
      },
      activeIndex: cubit.currentIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.smoothEdge,
      leftCornerRadius: 20,
      rightCornerRadius: 20,
      onTap: cubit.changeIndex,
    );
  }
}
