import 'dart:async';

import 'package:basket/components/area_component.dart';
import 'package:basket/components/ball_component.dart';
import 'package:basket/components/floor_component.dart';
import 'package:basket/theme/graphics.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/layout.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';

class BasketGame extends Forge2DGame {
  final FloorComponent floor = FloorComponent();

  BasketGame() : super(zoom: 1, gravity: Forge2DGame.defaultGravity * 10);

  @override
  Color backgroundColor() => const Color(0xFFF5C347);

  @override
  Future<void> onLoad() async {
    // debugMode = kDebugMode;

    await BasketGraphics.load();

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
