import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plantie/shared/styles/icon_broken.dart';
import '../shared/styles/colors.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return Scaffold(
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: () {
              // logic for take photo (just call the method here)
            },
            backgroundColor: plantieColor,
            child: Icon(
              size: 34,
              IconBroken.Camera,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
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
                  Icon(
                    cubit.iconList[index],
                    size: 24,
                    color: color,
                  ),
                  Text(
                    cubit.titles[index],
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            },
            activeIndex: cubit.currentIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.smoothEdge,
            leftCornerRadius: 20,
            rightCornerRadius: 20,
            onTap: (index) {
              cubit.changeIndex(index);
            },
          ),
        );
      },
    );
  }
}
