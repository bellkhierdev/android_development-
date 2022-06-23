//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:issue/screens/auth/welcome_page.dart';
import 'package:issue/screens/auth/widgets/onboarding_item.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'widgets/mycustompainter.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    systemTheme(themeData);
    return Scaffold(
      backgroundColor: StyleWidget.primaryClr,
      body: Consumer<StateAuth>(
        builder: (context, cubit, child) {
          return SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                        width: 100.w,
                        height: 95.h,
                        color: StyleWidget.primaryClr,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: TextButton(
                                      onPressed: () {
                                        _pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeIn);

                                        cubit.currantIndex > 0
                                            ? cubit.removeFromIndex()
                                            : null;
                                      },
                                      child: Text(
                                        'رجوع',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            ?.copyWith(
                                              fontSize: 13.sp,
                                              color: Colors.white,
                                            ),
                                      ).onTap(() {
                                        _pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeIn);

                                        cubit.currantIndex > 0
                                            ? cubit.removeFromIndex()
                                            : null;
                                      }),
                                    ),
                                  ),
                                  CustomDots(myIndex: cubit.currantIndex),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      width: 100.w,
                      height: 90.h,
                      child: CustomPaint(
                        painter: const MyCustomPainter(color: Colors.white),
                        child: SizedBox(
                          width: 80.w,
                          height: 50.h,
                          child: PageView.builder(
                            itemCount: onBoardingList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            itemBuilder: ((context, index) {
                              return OnBoardingItem(
                                index: index,
                                image: onBoardingList[index].img,
                                title: onBoardingList[index].title,
                                description: onBoardingList[index].description,
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    cubit.currantIndex != onBoardingList.length - 1
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: MyButton1(
                                  color: StyleWidget.primaryClr,
                                  width: 21.w,
                                  title: 'تخطي',
                                  func: () {
                                    _pageController.animateToPage(
                                        onBoardingList.length - 1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeOut);
                                    cubit.currantIndex <
                                            onBoardingList.length - 1
                                        ? cubit.skipIndex()
                                        : null;
                                  }),
                            ))
                        : Container(),
                    Positioned(
                      bottom: 10.h,
                      child: CircularButton(
                          color: const Color.fromARGB(255, 89, 180, 216),
                          width: 30.w,
                          icon: Icons.arrow_right_alt_sharp,
                          condition:
                              cubit.currantIndex != onBoardingList.length - 1,
                          func: () async {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                            if (cubit.currantIndex <
                                onBoardingList.length - 1) {
                              cubit.changeIndex();
                            } else {
                              await FuSharedPreferences.setBool(
                                  'openApp', true);

                              Navigator.pushAndRemoveUntil(
                                context,
                                CostumeTransition(const WelcomePage()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}

class OnBoardingModel {
  final String img;
  final String title;
  final String description;

  const OnBoardingModel(
      {required this.img, required this.title, required this.description});
}

class CircularButton extends StatelessWidget {
  const CircularButton(
      {Key? key,
      required this.color,
      required this.width,
      required this.icon,
      required this.func,
      required this.condition})
      : super(key: key);

  final Color color;
  final double width;
  final IconData icon;
  final Function() func;
  final bool condition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: func,
          child: Center(
            child: (condition)
                ? Icon(
                    icon,
                    color: StyleWidget.white,
                    size: 30.sp,
                  )
                : Text(
                    'بدأ'.padLeft(4),
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 14.sp,
                        color: StyleWidget.white,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}

class CustomDots extends StatelessWidget {
  final int myIndex;
  const CustomDots({Key? key, required this.myIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.w,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDot(0),
          _buildDot(1),
          _buildDot(2),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == myIndex ? StyleWidget.white : Colors.white54),
    );
  }
}
