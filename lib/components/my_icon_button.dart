import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final Icon icon;
  final Color buttonColor;
  final double buttonHeight;
  final double buttonWidth;
  final VoidCallback onPressed;

  const MyIconButton({
    super.key,
    required this.icon,
    required this.buttonColor,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
