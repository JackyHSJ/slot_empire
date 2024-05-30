

import 'package:example_slot_game/const/enum.dart';

class GameBlockModel {
  GameBlockModel({
    required this.type,
    this.coverNumber = 1
  });

  GameBlockType type;
  num coverNumber;
}