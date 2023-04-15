import 'dart:ui';

import 'package:basket/theme/constant.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';

class AreaComponent extends PositionComponent {
  AreaComponent({super.children});

  late Vector2 canvasSize;

  @override
  void onGameResize(Vector2 size) {
    this.size = kTargetSize.toVector2();

    canvasSize = size;
    position = canvasSize / 2 - this.size / 2;

    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    if (kDebugMode) {
      const double strokeWidth = 7;
      final rect = Rect.fromLTWH(0, 0, width, height).deflate(strokeWidth / 2);

      canvas.drawRect(
        rect,
        BasicPalette.black.withAlpha(24).paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }

    super.render(canvas);
  }
}
