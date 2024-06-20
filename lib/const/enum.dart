

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
  /// 橫式
  landscape,
  /// 直式
  portrait
}

enum SpinType {
  spin,
  stop,
  none
}

enum SlotGameStatus {
  init, // 使用者正在初始狀態
  spin,
  stop,
  win,
}