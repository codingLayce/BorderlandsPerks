import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vec;

typedef OnTapCallback = void Function();

class ZoomAnimationWrapper extends StatefulWidget {
  final Widget child;
  final OnTapCallback? onTap;
  final OnTapCallback? onDoubleTap;
  final OnTapCallback? onLongPress;
  final bool disableDoubleTap;

  const ZoomAnimationWrapper(
      {required this.child,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      this.disableDoubleTap = false,
      Key? key})
      : super(key: key);

  @override
  State createState() => _ZoomAnimationWrapper();
}

class _ZoomAnimationWrapper extends State<ZoomAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late Animation _tapAnimation;
  late AnimationController _tapAnimationController;

  @override
  void initState() {
    super.initState();
    // TAP
    _tapAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _tapAnimation = Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
        parent: _tapAnimationController, curve: Curves.easeInOut))
      ..addListener(() {
        if (_tapAnimationController.isCompleted) {
          _tapAnimationController.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _tapAnimationController.forward();
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        onDoubleTap: () {
          if (widget.disableDoubleTap) {
            return;
          }
          _tapAnimationController.forward();
          if (widget.onDoubleTap != null) {
            widget.onDoubleTap!();
          }
        },
        onLongPress: () {
          if (widget.onLongPress != null) {
            widget.onLongPress!();
          }
        },
        child: AnimatedBuilder(
            animation: _tapAnimationController,
            builder: (context, child) {
              return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.diagonal3(vec.Vector3(_tapAnimation.value,
                      _tapAnimation.value, _tapAnimation.value)),
                  child: widget.child);
            }));
  }
}
