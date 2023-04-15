import 'dart:async';

import 'package:flame_svg/flame_svg.dart';

// todo(melvspace): refactor dependency singleton
class BasketGraphics {
  static BasketGraphics? _instance;
  static BasketGraphics get instance {
    if (_instance == null) throw StateError("BasketGraphics not loaded. Call [BasketGraphics.load]");

    return _instance!;
  }

  final List<Svg> balls;

  BasketGraphics._(this.balls);

  static FutureOr<BasketGraphics> load() async {
    if (_instance != null) return _instance!;

    final balls = await Future.wait([Svg.load('images/ball_01.svg')]);

    return _instance = BasketGraphics._(balls);
  }
}
