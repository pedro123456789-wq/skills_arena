import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final textController;
  final double fontSize;
  final String defaultText;
  final bool isPassword;

  TextInput(this.textController,
      this.fontSize,
      this.defaultText,
      {this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      cursorColor: Colors.greenAccent,
      controller: textController,
      autofocus: false,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: defaultText,
        hintStyle: TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'PermanentMarker',
          fontSize: fontSize,
        ),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.greenAccent,
        fontFamily: 'PermanentMarker',
        fontSize: fontSize,
      ),
    );
  }
}
