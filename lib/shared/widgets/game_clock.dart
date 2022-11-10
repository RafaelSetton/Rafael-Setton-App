import 'package:flutter/material.dart';
import 'dart:math';

const double clockSize = 75;

class GameClock extends StatefulWidget {
  final Function() onTimerEnd;
  const GameClock({Key? key, required this.onTimerEnd}) : super(key: key);

  @override
  State<GameClock> createState() => _GameClockState();
}

class _GameClockState extends State<GameClock> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 2 * pi);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onTimerEnd();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: clockSize,
      width: clockSize,
      child: CustomPaint(
        child: Container(),
        painter: MyPainter(animation.value),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  double value;

  MyPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    int delta = value * 255 ~/ pi;

    Paint paint = Paint()
      ..color = Color.fromARGB(255, min(delta, 255), min(510 - delta, 255), 0);
    canvas.drawCircle(const Offset(clockSize / 2, clockSize / 2), clockSize / 2,
        Paint()..color = Colors.grey);
    canvas.drawArc(const Rect.fromLTRB(0, 0, clockSize, clockSize), -pi / 2,
        value, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
