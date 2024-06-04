import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:example_slot_game/base_view_model.dart';
import 'package:example_slot_game/const/global_data.dart';
import 'package:example_slot_game/slot_game/slot_game.dart';
import 'package:example_slot_game/slot_game_center/slot_game_center.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GameWidget(
        game: SlotGameCenter(),
        backgroundBuilder: (context) {
          return Image.asset(
            'assets/images/Background/Bg1.png',
            height: size.height, width: size.width,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}
