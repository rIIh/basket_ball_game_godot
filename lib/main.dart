import 'package:basket/basket_game.dart';
import 'package:basket/theme/constant.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MediaQuery.fromWindow(
      child: const BasketGameWidget(),
    ),
  );
}

class BasketGameWidget extends StatefulWidget {
  const BasketGameWidget({super.key});

  @override
  State<BasketGameWidget> createState() => _BasketGameWidgetState();
}

class _BasketGameWidgetState extends State<BasketGameWidget> {
  final game = BasketGame();

  @override
  Widget build(BuildContext context) {
    final ratio = MediaQuery.of(context).size.aspectRatio;
    final targetRatio = kTargetSize.aspectRatio;

    final fitWidth = ratio <= targetRatio;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              child: SizedBox(
                width: fitWidth ? kTargetSize.width : kTargetSize.height * ratio,
                height: fitWidth ? kTargetSize.width / ratio : kTargetSize.height,
                child: GameWidget(game: game),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
