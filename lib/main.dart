import 'dart:math';
import 'package:animation_training/loadinganim.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LogoApp(),
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 250);
  static final _rotationTween = Tween<double>(begin: 1, end: 0);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Transform.rotate(
        angle: _rotationTween.evaluate(animation) * pi,
        child: Opacity(
          opacity: _opacityTween.evaluate(animation),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: _sizeTween.evaluate(animation),
            width: _sizeTween.evaluate(animation),
            child: const FlutterLogo(
              style: FlutterLogoStyle.horizontal,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedLineColor extends AnimatedWidget {
  const AnimatedLineColor({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  static final ColorTween _colorTween =
      ColorTween(end: Colors.blue, begin: Colors.white);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      color: _colorTween.evaluate(animation),
      height: 3,
      width: double.maxFinite,
    );
  }
}

class LogoApp extends StatefulWidget {
  const LogoApp({Key? key}) : super(key: key);

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with TickerProviderStateMixin {
  late Animation<double> animation;
  late Animation<double> animationColor;
  late AnimationController controller;
  late AnimationController loadingController;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loadingController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat();

    animationColor = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedLineColor(animation: animation),
                  AnimatedLogo(animation: animation),
                  AnimatedLineColor(animation: animation),
                ],
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(future: Future.delayed(Duration(seconds: 5)),builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                      return Container(width: 60,height: 60,child: CupertinoLoadingAnimation(isDone: true,));
                    }else{
                      return Container(width: 60,height: 60,child: CupertinoLoadingAnimation(isDone: false,));
                    }
                  },
                  )
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
