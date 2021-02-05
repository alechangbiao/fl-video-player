import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'dart:math' as math;

const Duration long = Duration(seconds: 8);
const Duration medium = Duration(seconds: 6);
const Duration short = Duration(seconds: 4);

class V2Snackbar {
  /// Display a material snackbar
  static void show({required BuildContext context, Duration duration = medium}) {
    ThemeData _theme = Theme.of(context);
    SnackBar _snackbar = SnackBar(
      duration: duration,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Yay! A SnackBar!'),
          CountDownTimer(duration: duration),
        ],
      ),
      action: SnackBarAction(
        // textColor: _theme.primaryTextTheme.bodyText1.color,
        label: 'UNDO',
        onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
      ),
    );

    // Scaffold.of(context).showSnackBar(_snackbar);
    ScaffoldMessenger.of(context).showSnackBar(_snackbar);
  }
}

class CountDownTimer extends StatefulWidget {
  final double size;
  final Duration duration;

  const CountDownTimer({Key? key, this.size = 26, this.duration = medium}) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  late AnimationController controller;

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return duration.inSeconds.toString();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
  }

  @override
  void dispose() {
    controller.dispose(); // this needs to be called before `super.dispose()`
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Align(
        alignment: FractionalOffset.center,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget? child) {
                    return CustomPaint(
                      painter: TimerPainter(
                        animation: controller,
                        backgroundColor: Colors.white12,
                        color: AppColors.iconYellowDark,
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: FractionalOffset.center,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget? child) {
                    return Text(
                      timerString,
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;

  TimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant TimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
