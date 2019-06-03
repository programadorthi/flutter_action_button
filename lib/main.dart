import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kButtonSize = 60.0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Action Button Interaction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Floating Action Button Interaction'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _buttonAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonAnim = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.25,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CardContainer(
                  parentController: _controller,
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _buttonAnim,
            builder: (context, child) {
              return FloatingButton(
                animation: _buttonAnim,
                forward: _controller.velocity > 0,
                screenSize: screenSize,
                clickCallback: startAnimation,
              );
            },
          ),
        ],
      ),
    );
  }
}

class CardContainer extends StatefulWidget {
  final AnimationController parentController;
  final Tween<double> borderRadius;

  CardContainer({
    Key key,
    this.parentController,
  })  : borderRadius = Tween(
          begin: 40.0,
          end: 10.0,
        ),
        super(key: key);

  @override
  _CardContainerState createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    var parentController = widget.parentController;

    parentController.addListener(() {
      if (parentController.value > 0.95 &&
          (!_controller.isAnimating || !_controller.isCompleted)) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0 * widget.parentController.value,
      width: 200.0 * widget.parentController.value,
      child: Card(
        color: Colors.black,
        elevation: 12.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius.evaluate(widget.parentController),
          ),
        ),
        child: Opacity(
          opacity: widget.parentController.isAnimating ||
                  widget.parentController.value < 0.9
              ? 0.0
              : 1.0,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              MenuItem(
                icon: CupertinoIcons.photo_camera,
                iconAnimation: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.0,
                    0.2,
                    curve: Curves.easeIn,
                  ),
                ),
                iconAnimationStartAngle: -math.pi / 2,
                parentBackgroundColor: Colors.black,
                text: 'Photo',
                textAnimation: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.15,
                    0.25,
                    curve: Curves.ease,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              MenuItem(
                icon: CupertinoIcons.book,
                iconAnimation: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.0,
                    0.5,
                    curve: Curves.easeIn,
                  ),
                ),
                iconAnimationStartAngle: math.pi / 2,
                parentBackgroundColor: Colors.black,
                text: 'Files',
                textAnimation: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.4,
                    0.5,
                    curve: Curves.ease,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              MenuItem(
                icon: CupertinoIcons.mic,
                iconAnimation: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.0,
                    0.75,
                    curve: Curves.easeIn,
                  ),
                ),
                iconAnimationStartAngle: -math.pi / 2,
                parentBackgroundColor: Colors.black,
                text: 'Record',
                textAnimation: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.65,
                    0.75,
                    curve: Curves.ease,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              MenuItem(
                icon: CupertinoIcons.conversation_bubble,
                iconAnimation: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.0,
                    1.0,
                    curve: Curves.easeIn,
                  ),
                ),
                iconAnimationStartAngle: math.pi * 0.75,
                parentBackgroundColor: Colors.black,
                text: 'New email',
                textAnimation: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.9,
                    1.0,
                    curve: Curves.ease,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  final Animation<double> animation;
  final bool forward;
  final Size screenSize;
  final VoidCallback clickCallback;

  FloatingButton({
    Key key,
    @required this.animation,
    @required this.forward,
    @required this.screenSize,
    @required this.clickCallback,
  }) : super(key: key);

  Offset _getButtonOffset() =>
      Offset(50.0 * animation.value, 140.0 * animation.value);

  double _getIconXPosition() {
    var position = 50.0 * animation.value;
    if (forward) {
      return position;
    }
    return -position;
  }

  @override
  Widget build(BuildContext context) {
    double centerX = screenSize.width / 2;
    double centerY = screenSize.height / 2;
    double centerButton = kButtonSize / 2;
    Offset offset = _getButtonOffset();

    return Positioned(
      left: centerX - centerButton + offset.dx,
      top: centerY - centerButton + offset.dy,
      child: ClipOval(
        child: GestureDetector(
          onTap: clickCallback,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              shape: BoxShape.circle,
            ),
            height: kButtonSize,
            width: kButtonSize,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Transform.rotate(
                  angle: math.pi * animation.value,
                  child: Icon(
                    CupertinoIcons.clear_thick,
                    color: Colors.white,
                    size: 24.0 * animation.value,
                  ),
                ),
                Transform.rotate(
                  angle: -math.pi / 4,
                  child: Transform.translate(
                    offset: Offset(_getIconXPosition(), 0.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  final IconData icon;
  final Animation<double> iconAnimation;
  final double iconAnimationStartAngle;
  final Color parentBackgroundColor;
  final String text;
  final Animation<double> textAnimation;

  const MenuItem({
    Key key,
    @required this.icon,
    @required this.iconAnimation,
    @required this.iconAnimationStartAngle,
    @required this.parentBackgroundColor,
    @required this.text,
    @required this.textAnimation,
  }) : super(key: key);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomPaint(
          foregroundPainter: IconRevealPainter(
            animation: widget.iconAnimation,
            foregroundColor: widget.parentBackgroundColor,
            startAngle: widget.iconAnimationStartAngle,
          ),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 32.0,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        SizedBox(
          height: 32.0,
          width: 100.0,
          child: Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: widget.textAnimation,
                builder: (ctx, child) {
                  return Positioned(
                    top: 8.0 + (32.0 * (1.0 - widget.textAnimation.value)),
                    child: Text(
                      widget.text.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IconRevealPainter extends CustomPainter {
  final Animation<double> animation;
  final Color foregroundColor;
  final double startAngle;

  IconRevealPainter({
    @required this.animation,
    @required this.foregroundColor,
    this.startAngle = 0.0,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = foregroundColor
      ..strokeCap = StrokeCap.round;

    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, startAngle, progress, true, paint);
  }

  @override
  bool shouldRepaint(IconRevealPainter old) {
    return foregroundColor != old.foregroundColor;
  }
}
