import 'package:flutter/material.dart';
import 'package:google_notes/utilities/constants.dart';

class InputBox extends StatelessWidget {
  InputBox({@required this.text, this.hintText, this.textCapitalization});

  final text;
  final hintText;
  final textCapitalization;
  var input;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: kInputBoxStyle,
          hintText: hintText,
          hintStyle: kInputBoxStyle.copyWith(fontSize: 16.0),
          contentPadding: EdgeInsets.all(16.0),
          filled: true,
          fillColor: kInputBoxColor,
          alignLabelWithHint: true,
          border:
        ),
        style: kInputBoxInputTextStyle,
        maxLines: 3,
        onChanged: (val) {
          input = val;
        },
      ),
    );
  }
}
