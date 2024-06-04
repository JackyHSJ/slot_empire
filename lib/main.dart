import 'package:example_slot_game/slot_game/slot_game.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSpineFlutter();
  runApp(const ProviderScope(child: SlotGame()));
}
