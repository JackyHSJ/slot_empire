

enum GameBlockType {
  blockJ, blockQ, blockK, blockA,
  ten,
  totemBird,
  totemFace,
  totemGrass,
  totemKing,
  totemDoll,
  wild,
  scatter,
  none
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

@Deprecated('即將廢除')
enum SpinType {
  spin,
  stop,
  none
}

enum SlotStatus {
  init, // 使用者正在初始狀態
  spin,
  stop,
  win,
}



enum SlotGameStatus {
  mainGame, // 使用者正在初始狀態
  freeGame,
}