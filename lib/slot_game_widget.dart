
import 'package:example_slot_game/provider/provider.dart';
import 'package:example_slot_game/slot_game_center/slot_game_center.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlotGameWidget extends ConsumerStatefulWidget {
  const SlotGameWidget({super.key});

  @override
  ConsumerState<SlotGameWidget> createState() => _SlotGameWidgetState();
}

class _SlotGameWidgetState extends ConsumerState<SlotGameWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RiverpodAwareGameWidget(
        key: gameWidgetKey,
        game: SlotGameCenter(),
      ),
    );
  }
}
