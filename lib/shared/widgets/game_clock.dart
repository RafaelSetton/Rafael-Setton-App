import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

const double clockSize = 75;
const double answerValue = 0.7;
const double tick = 0.2;

class GameClockCountDownController {
  final double _clockDuration;
  late double _currentTime;
  Timer _timer = Timer(Duration.zero, () {});
  final void Function()? onChange;

  GameClockCountDownController(this._clockDuration, {this.onChange}) {
    if (this._clockDuration <= 0)
      throw Exception("_clockDuration deve ser positivo");
    this._currentTime = _clockDuration;
  }

  set currentTime(double time) {
    _currentTime = max(min(time, _clockDuration), 0);
    if (onChange != null) onChange!();
  }

  double get currentTime => _currentTime;
  double get clockDuration => _clockDuration;

  void countDown(double diff) => currentTime = _currentTime - diff;
  void countUp(double diff) => currentTime = _currentTime + diff;

  void reset() {
    _currentTime = _clockDuration;
    pause();
  }

  void pause() {
    if (_timer.isActive) _timer.cancel();
  }

  void resume() {
    if (!_timer.isActive)
      _timer = Timer.periodic(
        Duration(milliseconds: 100),
        (timer) => countDown(tick),
      );
  }

  void dispose() {
    _timer.cancel();
  }
}

class GameClock extends StatefulWidget {
  final Function() onTimerEnd;
  final GameClockCountDownController countDownController;
  final Color backgroundColor, startColor, endColor;

  const GameClock(
      {Key? key,
      required this.onTimerEnd,
      required this.countDownController,
      this.backgroundColor = Colors.black,
      this.startColor = Colors.green,
      this.endColor = Colors.red})
      : super(key: key);

  @override
  State<GameClock> createState() => _GameClockState();
}

class _GameClockState extends State<GameClock> with TickerProviderStateMixin {
  @override
  void dispose() {
    widget.countDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.countDownController.currentTime == 0) {
      widget.onTimerEnd();
      widget.countDownController.reset();
    }
    return SizedBox(
      height: clockSize,
      width: clockSize,
      child: CustomPaint(
        child: Container(),
        painter: MyPainter(
          widget.countDownController,
          widget.backgroundColor,
          widget.startColor,
          widget.endColor,
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  late double percentDone;
  final Color backgroundColor, startColor, endColor;

  MyPainter(controller, this.backgroundColor, this.startColor, this.endColor) {
    percentDone = controller.currentTime / controller.clockDuration;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Color foreGroundColor = Color.fromARGB(
      (startColor.alpha * percentDone + endColor.alpha * (1 - percentDone))
          .toInt(),
      (startColor.red * percentDone + endColor.red * (1 - percentDone)).toInt(),
      (startColor.green * percentDone + endColor.green * (1 - percentDone))
          .toInt(),
      (startColor.blue * percentDone + endColor.blue * (1 - percentDone))
          .toInt(),
    );

    canvas.drawCircle(const Offset(clockSize / 2, clockSize / 2), clockSize / 2,
        Paint()..color = backgroundColor);

    canvas.drawArc(const Rect.fromLTRB(0, 0, clockSize, clockSize), -pi / 2,
        2 * pi * percentDone, true, Paint()..color = foreGroundColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
