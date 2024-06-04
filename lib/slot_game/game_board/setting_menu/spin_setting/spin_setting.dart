
import 'package:example_slot_game/util/web/inappweb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpinSetting extends ConsumerStatefulWidget {
  const SpinSetting({super.key});

  @override
  ConsumerState<SpinSetting> createState() => _SpinSettingState();
}

class _SpinSettingState extends ConsumerState<SpinSetting> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder( // 設定圓角的形狀
          borderRadius: BorderRadius.circular(5), // 這裡的數值可以調整圓角的大小
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('title', style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black
              )),
              SizedBox(height: 8),
              Text('subTitle', style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black
              ),),
              SizedBox(height: 16),
              _buildBtnRow()
            ],
          ),
        )
    );
  }

  _buildBtnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCancelBtn(),
        _buildConfirmBtn(),
      ],
    );
  }

  _buildConfirmBtn() {
    return Container(
      width: 90,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(2)
      ),
      child: Text('Start', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
    );
  }

  _buildCancelBtn() {
    return Container(
      width: 90,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2)
      ),
      child: Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
    );
  }
}