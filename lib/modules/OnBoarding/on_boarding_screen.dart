import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../WelcomePlantie/welcome_screen.dart';

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
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/onBoardingImages/10.jpg',
      title: 'Welcome to Plantie!',
      body: 'Stay updated with real-time weather and plant care advice tailored to your needs, and calculate the right amount of fertilizer for optimal plant growth.',
    ),
    BoardingModel(
      image: 'assets/images/onBoardingImages/13.png',
      title: 'Detect Plant Diseases',
      body: 'Upload a photo of your plant to identify diseases and get expert solutions instantly.',
    ),
    BoardingModel(
      image: 'assets/images/onBoardingImages/10.jpg',
      title: 'Find Nearby Plant Stores',
      body: 'Easily locate nearby plant stores with just a tap, helping you take better care of your plants.',
    ),
    BoardingModel(
      image: 'assets/images/onBoardingImages/12.jpg',
      title: 'Join the Plantie Community',
      body: 'Connect with fellow plant lovers, share tips, and learn from each other to grow your green space together.',
    ),
  ];

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value)
    {
      if (value) {
        navigateAndFinish(
          context,
          WelcomeScreen(),
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
            text: 'skip',
            isUperCase: true
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: plantieColor,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5.0,
                  ),
                  count: boarding.length,
                ),
                Spacer(),
                FloatingActionButton(
                  backgroundColor: plantieColor,
                  shape: const CircleBorder(),
                  onPressed: () {
                    if (isLast)
                    {
                      submit();
                    } else {
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    color: Colors.white,
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage('${model.image}'),
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      Text(
        '${model.title}',
        style: TextStyle(
          fontSize: 28.0,
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Text(
        '${model.body}',
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
    ],
  );
}