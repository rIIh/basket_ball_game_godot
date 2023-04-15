import 'package:basket/theme/graphics.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_svg/flame_svg.dart';

class BallComponent extends BodyComponent with TapCallbacks {
  static const _kBottomOffset = 75;

  double _horizontalAlignment;
  late Vector2 _position;

  final Svg svg = BasketGraphics.instance.balls.first;

  BallComponent({double horizontalAlignment = 0})
      : _horizontalAlignment = horizontalAlignment,
        super();

  @override
  void onParentResize(Vector2 maxSize) {
    if (!isMounted) {
      _position = Vector2(
        maxSize.x / 2 + (maxSize.x / 2 * _horizontalAlignment),
        maxSize.y - _kBottomOffset - svg.pictureInfo.size.height / 2,
      );
    }

    super.onParentResize(maxSize);
  }

  @override
  Body createBody() {
    final shape = CircleShape();
    shape.radius = svg.pictureInfo.size.longestSide / 2;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0,
      density: 1,
      friction: 0,
      userData: this,
    );

    final bodyDef = BodyDef(
      userData: this,
      angularDamping: 0.8,
      isAwake: false,
      position: _position,
      type: BodyType.dynamic,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() {
    add(
      SvgComponent(
        svg: svg,
        size: svg.pictureInfo.size.toVector2(),
        anchor: Anchor.center,
      ),
    );
    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapDown(_) {
    body.applyLinearImpulse(Vector2(0, -1) * 5000000000, wake: true);
  }
}
