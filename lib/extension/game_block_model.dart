import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/model/game_block_model.dart';

extension GameBlockModelExtension on GameBlockModel {
  String get getBlockImgPath {
    switch(coverNumber) {
      case 1:
        return type.getBlockImgPath(coverNumber);
      case 2:
        return type.getBlockImgPath(coverNumber);
      case 3:
        return type.getBlockImgPath(coverNumber);
      case 4:
        return type.getBlockImgPath(coverNumber);
      default:
        return '';
    }
  }
}
