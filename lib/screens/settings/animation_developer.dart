//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:issue/export.dart';
import 'utils.dart';

enum AnimProps { opacity, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({ Key? key, required this.delay, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimProps>()
      ..add(AnimProps.opacity, Tween(begin: 0.0, end: 1.0))
      ..add(AnimProps.translateY, Tween(begin: 120.0, end: 0.0));
    return PlayAnimation<MultiTweenValues<AnimProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: const Duration(milliseconds: 500),
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AnimProps.opacity),
        child: Transform.translate(
          offset: Offset(0, value.get(AnimProps.translateY)),
          child: child,
        ),
      ),
    );
  }
}




class AnimationDeveloper extends StatefulWidget {
  const AnimationDeveloper({Key? key}) : super(key: key);

  @override
  _AnimationDeveloperState createState() => _AnimationDeveloperState();
}

class _AnimationDeveloperState extends State<AnimationDeveloper> {

  late PageController backPageViewController;
  late PageController frontPageViewController;

  int currentPage = 0;

  @override
  void initState() {
    backPageViewController = PageController(initialPage: UtilsSettings.images.length - 1);
    frontPageViewController = PageController(viewportFraction: .8);
    frontPageViewController.addListener(() {
      int next = frontPageViewController.page!.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }
@override
  void deactivate() {
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: backPageViewController,
            children: <Widget>[
              // page(image: images[3]),
              page(image: UtilsSettings.images[2]),
              page(image: UtilsSettings.images[1]),
              page(image: UtilsSettings.images[0]),
            ],
          ),
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: frontPageViewController,
            itemCount: UtilsSettings.images.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              bool active = (index == currentPage);
              return frontPage(
                  image: UtilsSettings.images[index], title: UtilsSettings.names[index], isActive: active,doing:  UtilsSettings.doing[index],);
            },
            onPageChanged: (index) {
              backPageViewController.animateToPage(
                UtilsSettings.images.length - 1 - index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            },
          )
        ],
      ),
    );
  }

  Widget frontPage({image, title, isActive, doing,}) {
    double paddingTop = isActive ? 100 : 150;
    double blur = isActive ? 30 : 0;
    double offset = isActive ? 20 : 0;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 400),
      padding: EdgeInsets.only(top: paddingTop, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: blur,
                    offset: Offset(offset, offset),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                    delay: 1.5,
                    
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                    delay: 2,
                    child: Text(
                     doing,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // const FadeAnimation(
                  //   delay: 2.5,
                  //   child: Text(
                  //     "4.0",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  // FadeAnimation(
                  //   delay: 3,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children:const <Widget>[
                  //        Icon(
                  //         Icons.star,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //        Icon(
                  //         Icons.star,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //        Icon(
                  //         Icons.star,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //        Icon(
                  //         Icons.star_border,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //        Icon(
                  //         Icons.star_border,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget page({image}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Container(
        color: Colors.black.withOpacity(.6),
      ),
    );
  }
}
