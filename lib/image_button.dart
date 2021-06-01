import './main.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImageButton extends StatelessWidget {
  final Function callback;
  final String imagePath;
  final String label;
  final double height;
  final double width;
  final double fontSize;

  ImageButton(
    this.callback,
    this.imagePath,
    this.label,
    this.height,
    this.width,
    this.fontSize,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
      ),
      child: Column(
        children: [
          Image(
            image: AssetImage(imagePath),
            height: height,
            width: width,
            alignment: Alignment.center,
            colorBlendMode: BlendMode.darken,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.redAccent,
              fontFamily: 'PermanentMarker',
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
