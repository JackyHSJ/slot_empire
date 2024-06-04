

import 'package:example_slot_game/model/game_block_model.dart';
import 'package:flame/components.dart';

class HorizontalBlockModel {
  HorizontalBlockModel({
    required this.spriteComponent,
    this.dropNumber = 1
  });

  SpriteComponent spriteComponent;
  num dropNumber;
}