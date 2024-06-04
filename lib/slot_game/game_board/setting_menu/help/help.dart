
import 'package:example_slot_game/util/web/inappweb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Help extends ConsumerStatefulWidget {
  const Help({super.key});

  @override
  ConsumerState<Help> createState() => _HelpState();
}

class _HelpState extends ConsumerState<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: InAppWebViewBrowser(
      //   url: 'https://jiligames.com/PlusIntro/103?showGame=false',
      // ),
    );
  }
}