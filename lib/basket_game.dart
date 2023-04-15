import 'dart:async';
import 'dart:ui';

import 'package:basket/components/area_component.dart';
import 'package:basket/components/ball_component.dart';
import 'package:basket/components/floor_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:flame/palette.dart';

class BasketGame extends FlameGame {
  final FloorComponent floor = FloorComponent();

  @override
  Color backgroundColor() => const Color(0xFFF5C347);

  @override
  FutureOr<void> onLoad() {
    add(
      AreaComponent(
        children: [
          AlignComponent(
            child: floor..size = Vector2(size.x, 157),
            alignment: Anchor.bottomCenter,
          )
        ],
      ),
    );

    add(
      AreaComponent(
        children: [
          BallComponent(),
        ],
      ),
    );

    // add(AreaComponent());

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    floor.width = canvasSize.x;
    super.onGameResize(canvasSize);
  }
}
