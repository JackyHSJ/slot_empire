

enum GameBlockType {
  blockJ, blockQ, blockK, blockA,
  king,
  ten,
  totemBird,
  totemFace,
  totemGrass,
  totemKing,
  totemDoll,
}

/// 遊戲排版模式。
enum LayoutMode {
  //尚未設定。
  none,
  //橫式
  landscape,
  //直式
  portrait
}

/// 遊戲排版模式。
enum SpinType {
  spin,
  stop,
  none
}