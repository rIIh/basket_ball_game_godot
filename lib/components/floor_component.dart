import 'dart:ui';

import 'package:basket/theme/colors.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class FloorComponent extends PositionComponent {
  BoxDecoration decoration = BoxDecoration(
    color: BasketColors.pink,
    border: Border(
      top: BorderSide(
        width: 7,
        color: BasketColors.black,
      ),
    ),
  );

  @override
  void render(Canvas canvas) {
    decoration.createBoxPainter().paint(
          canvas,
          Offset(0, 0),
          ImageConfiguration(size: Size(width, 1e6)),
        );
    super.render(canvas);
  }
}
