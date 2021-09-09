import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CupertinoLoadingAnimation extends StatefulWidget {
  const CupertinoLoadingAnimation({Key? key, this.isDone = false}) : super(key: key);
  final bool isDone;

  @override
  _CupertinoLoadingAnimationState createState() => _CupertinoLoadingAnimationState();
}

/// This is the private State class that goes with _CupertinoLoadingAnimationState.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _CupertinoLoadingAnimationState extends State<CupertinoLoadingAnimation>
    with TickerProviderStateMixin {

  late AnimationController circleController;
  late AnimationController loadingIconController;
  late AnimationController doneIconController;
  late Animation<double> circleAnimation;
  late Animation<double> loadingIconAnimation;
  late Animation<double> doneIconAnimation;

  @override
  void initState() {
    circleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat();

    /// why true? because we need to use curve hourglass_bottom icon
    loadingIconController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat(reverse: true);
    ///why use other controller its simple :) because we no need to repeat it
    doneIconController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    circleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(circleController);

    loadingIconAnimation =
        CurvedAnimation(parent: circleController, curve: Curves.easeInOutCubic);

    loadingIconController.forward();

    doneIconAnimation = CurvedAnimation(
        parent: doneIconController, curve: Curves.fastOutSlowIn);

    super.initState();
  }

  // this function check if bool done = true finish loading animation
  // and start done icon animation
  checkIsDone() async {
    if (widget.isDone) {
      loadingIconController.dispose();
      if (doneIconController.status != AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 100));
        doneIconController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkIsDone();
    return Stack(
      children: [
        widget.isDone
            ? SizeTransition(
              sizeFactor: doneIconAnimation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 35,
                ),
              ),
            )
            : RotationTransition(
              turns: loadingIconAnimation,
              child: Center(child: Icon(Icons.hourglass_bottom,size: 30,)),
            ),
        RotationTransition(
          turns: circleAnimation,
          child: Center(
            child: SvgPicture.asset(
              'assets/circle.svg',
              width: 50,
              height: 50,
              color: Color(0xFF414141),
            ),
          ),
        ),
      ],
    );
  }
}
