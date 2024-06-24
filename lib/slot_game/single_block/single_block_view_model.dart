

import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:path/path.dart' as path;

class SingleBlockViewModel {

  String _getFileName(GameBlockModel gameBlockModel) {
    final String imgPath = gameBlockModel.type.getBlockImgPath(gameBlockModel.coverNumber);
    final String name = path.basenameWithoutExtension(imgPath);
    return name;
  }

  String getImgName(GameBlockModel gameBlockModel) {
    final String fileName = _getFileName(gameBlockModel);

    /// Wild例外
    if(fileName.contains('Wild') == true) {
      return fileName;
    }

    if(fileName.contains('Scatter') == true) {
      return 'H1';
    }

    final List<String> part = fileName.split('');
    return part[0] + part[1];
  }

  String getImgCover(GameBlockModel gameBlockModel) {
    final String fileName = _getFileName(gameBlockModel);
    final List<String> part = fileName.split('');
    return part[2];
  }
}