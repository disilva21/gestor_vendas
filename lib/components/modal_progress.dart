import 'package:flutter/material.dart';

class ModalLoading extends StatelessWidget {
  final bool isLoading;
  final bool? dismissible;
  final Widget child;

  const ModalLoading({Key? key, required this.isLoading, this.dismissible = false, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    return Stack(
      children: [
        child,
        Opacity(
          child: ModalBarrier(
            dismissible: dismissible!,
            color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
          ),
          opacity: 0.5,
        ),
        const Loading(),
      ],
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<num> _animation;
  //Animation? sizeAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(minutes: 2));
    _animation = Tween(begin: 0, end: 5 * 60 * 3.14).animate(_controller!);
    // sizeAnimation = Tween<double>(begin: 100.0, end: 130.0).animate(_controller!);
    _controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: _animation.value.toDouble(),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: Image.asset(
                'assets/images/menu_mania_letra.png',
                width: 140,
              ),
            ),
          );
        },
      ),
    );
  }
}
