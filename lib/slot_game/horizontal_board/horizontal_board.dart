import 'dart:developer';

import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/slot_game/horizontal_board/horizontal_board_view_model.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board_view_model.dart';
import 'package:flame/components.dart';

class HorizontalBoard extends PositionComponent {
  // HorizontalBoard({
  //   required this.horizontalIndex,
  //   required this.gameBlockMap,
  // });
  //
  // int horizontalIndex;
  // List<GameBlockModel> gameBlockMap;

  late HorizontalBoardViewModel viewModel;

  @override
  Future<void> onLoad() async {
    viewModel = HorizontalBoardViewModel();
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }
}
