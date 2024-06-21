import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:example_slot_game/base_view_model.dart';
import 'package:example_slot_game/const/global_data.dart';
import 'package:example_slot_game/launch/launch_view_model.dart';
import 'package:example_slot_game/slot_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Launch extends ConsumerStatefulWidget {
  const Launch();

  @override
  ConsumerState<Launch> createState() => _LaunchState();
}

class _LaunchState extends ConsumerState<Launch> with AfterLayoutMixin {
  late LaunchViewModel viewModel;

  @override
  void initState() {
    viewModel = LaunchViewModel(ref: ref);
    super.initState();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    viewModel.afterFirstLayout();
    BaseViewModel.pushAndRemoveUntil(context, const SlotGameWidget());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Scaffold(
        appBar: null,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Text('launch'),
        ),
      ),
    );
  }
}
