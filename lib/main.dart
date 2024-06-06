import 'package:example_slot_game/slot_game/slot_game.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  debugProfileBuildsEnabled = true;
  debugProfileBuildsEnabledUserWidgets = true;
  debugProfileLayoutsEnabled = true;
  debugProfilePaintsEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();
  await initSpineFlutter();
  runApp(const ProviderScope(child: SlotGame()));
}
