import 'package:chat_with_me/constants/methods.dart';
import 'package:flutter/material.dart';

class MyAnimatedButton extends StatefulWidget {
  final String text;
  final Color color;
  final TextStyle textStyle;
  final Function onAnimated;

  const MyAnimatedButton({
    super.key,
    required this.text,
    required this.color,
    required this.textStyle,
    required this.onAnimated,
  });

  @override
  _MyAnimatedButtonState createState() => _MyAnimatedButtonState();
}

class _MyAnimatedButtonState extends State<MyAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });

    _controller.forward().then((_) {
      widget.onAnimated(); // Call the function after animation completes
    });

    // Simulate a loading process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds:600),
      width: isLoading ? 50.0 : getWidth(context)*.9,
      height: 50.0,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(isLoading ? 25.0 : 20),
      ),
      child: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : TextButton(
        onPressed: startLoading,
        child: Text(
          widget.text,
          style: widget.textStyle,
        ),
      ),

    );
  }
}