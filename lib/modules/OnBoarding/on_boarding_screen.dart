// lib/modules/OnBoarding/on_boarding_screen.dart
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../generated/l10n.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/app_colors.dart';
import '../Registration/registration_screen.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController boardController = PageController();
  late List<BoardingModel> boarding;
  bool isLast = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    boarding = _buildBoardingItems(context);
    // ✅ Pre-cache all images to avoid loading delays when swiping
    _precacheImages();
  }

  List<BoardingModel> _buildBoardingItems(BuildContext context) {
    return [
      BoardingModel(
        image: 'assets/images/onBoardingImages/10.jpg',
        title: S.of(context).onboardingTitle1,
        body: S.of(context).onboardingBody1,
      ),
      BoardingModel(
        image: 'assets/images/onBoardingImages/13.png',
        title: S.of(context).onboardingTitle2,
        body: S.of(context).onboardingBody2,
      ),
      BoardingModel(
        image: 'assets/images/onBoardingImages/10.jpg',
        title: S.of(context).onboardingTitle3,
        body: S.of(context).onboardingBody3,
      ),
      BoardingModel(
        image: 'assets/images/onBoardingImages/12.jpg',
        title: S.of(context).onboardingTitle4,
        body: S.of(context).onboardingBody4,
      ),
    ];
  }

  void _precacheImages() {
    for (final item in boarding) {
      precacheImage(AssetImage(item.image), context);
    }
  }

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value && mounted) {
        navigateAndFinish(
          context,
          const RegistrationScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            function: submit,
            text: S.of(context).skip,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                // ✅ Pre‑build adjacent pages to reduce loading delay
                allowImplicitScrolling: true,
                onPageChanged: (int index) {
                  setState(() {
                    isLast = index == boarding.length - 1;
                  });
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: AppColors.primary,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5.0,
                  ),
                  count: boarding.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  shape: const CircleBorder(),
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => RepaintBoundary(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(model.image),
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          model.title,
          style: const TextStyle(fontSize: 28.0),
        ),
        const SizedBox(height: 15.0),
        Text(
          model.body,
          style: const TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 30.0),
      ],
    ),
  );
}