// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ColorContainer extends StatelessWidget {
  const ColorContainer({super.key, this.color, this.onTapColor, this.border});
  final Color? color;
  final VoidCallback? onTapColor;
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapColor,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border,
          boxShadow: [
            // Bottom-right darker shadow
            BoxShadow(
              color: Colors.black38,
              offset: Offset(4, 4),
              blurRadius: 6,
              spreadRadius: 1,
            ),
            // Top-left lighter highlight
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              offset: Offset(-4, -4),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
