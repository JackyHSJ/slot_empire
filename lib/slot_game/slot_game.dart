import 'package:example_slot_game/const/global_data.dart';
import 'package:example_slot_game/launch/launch.dart';
import 'package:flutter/material.dart';

class SlotGame extends StatelessWidget {
  const SlotGame({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golden Empire',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: GlobalData.globalKey,
      debugShowCheckedModeBanner: false,
      home: const Launch(),
    );
  }
}