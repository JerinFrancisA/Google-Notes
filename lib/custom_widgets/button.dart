import 'package:flutter/material.dart';
import 'package:google_notes/utilities/constants.dart';

class Button extends StatelessWidget {
  Button({@required this.text, @required this.onPressed});

  final text;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: GestureDetector(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: kInputBoxStyle.copyWith(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            shape: BoxShape.rectangle,
            color: kRedColor
          ),
          width: double.infinity,
        ),
        onTap: onPressed,
      ),
    );
  }
}