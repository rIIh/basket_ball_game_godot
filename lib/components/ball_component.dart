import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class BallComponent extends CircleComponent {
  static const _kSize = 131;

  BallComponent()
      : super(
          radius: _kSize / 2,
          paint: BasicPalette.orange.paint(),
          position: Vector2(130, 658),
          anchor: Anchor.center,
        );
}
