

import 'package:example_slot_game/const/global_cache.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/model/res/slot/detail_list_info/detail_list_info.dart';
import 'package:flame/components.dart';

class SingleBlockViewModel {

  String getImgName(Vector2 position) {
    final int x = position.x.round();
    final int y = position.y.round();
    final int matrixX = ((x - 72) / GlobalValue.blockVector.x).toInt();
    final int matrixY = (y / GlobalValue.blockVector.y).toInt() ;
    final int currentRound = GlobalCache.comboRoundCount.toInt();
    final DetailListInfo? info = GlobalCache.slotRes.detail?.detailList?[currentRound];
    final List<String?> list = info?.itemMap?[matrixX].reversed.toList() ?? [];
    final String nameStr = list[matrixY - 5] ?? '';
    if(nameStr == '') return '';
    final List<String> part = nameStr.split('');
    return part[0] + part[1];
  }
}