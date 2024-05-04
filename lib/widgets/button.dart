import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    this.onPressed,
    required this.backgroundColor,
    required this.text,
    required this.borderColor,
    required this.textColor,
    required this.paddHori,
    required this.paddver,
    required this.radiuscir,
  }) : super(key: key);

  final Function()? onPressed;
  final Color backgroundColor;
  final String text;
  final Color borderColor;
  final Color textColor;
  final double paddHori;
  final double paddver;
  final double radiuscir;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiuscir),
          side: BorderSide(color: borderColor, width: 3.0),
        ),
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: paddHori, vertical: paddver),
        textStyle: const TextStyle(
            letterSpacing: 1,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "Papillon"),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(letterSpacing: 1, color: textColor),
      ),
    );
  }
}
