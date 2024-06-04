import 'package:example_slot_game/base_view_model.dart';
import 'package:flutter/material.dart';

class BaseDialog {
  BaseDialog(this.context);
  BuildContext context;

  buildAlertDialog({
    Widget? title,
    Widget? content,
    List<Widget>? action,
    MainAxisAlignment actionsAlignment = MainAxisAlignment.center,
    bool isBackGroundGradient = false,
    bool isDialogCancel = true,
    Color? backgroundColor,
  }) {
    showTransparentDialog(
      isDialogCancel: isDialogCancel,
      widget: AlertDialog(
        backgroundColor: backgroundColor ?? Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        actionsPadding: EdgeInsets.only(right: 16, bottom: 20, left: 16),
        titlePadding: EdgeInsets.only(top: 20, right: 16, left: 16),
        title: title,
        content: Container(
          decoration: isBackGroundGradient ? const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(169, 224, 255, 1),
                Color.fromRGBO(228, 200, 255, 1)
              ], // 渐变色
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ) : null,
          child: content,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        actionsAlignment: actionsAlignment,
        actions: action,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      )
    );
  }

  buildDialog({required Widget child, bool isDialogCancel = true}) {
    showTransparentDialog(
      isDialogCancel: isDialogCancel,
      widget: PopScope(
        canPop: isDialogCancel ? true : false,
        onPopInvoked: (didPop) {},
        child: Dialog(
          child: child,
        ),
      )
    );
  }

  showTransparentDialog({
    bool isDialogCancel = true,
    required Widget widget,
    Object? arguments
  }) {
    final RouteSettings routeSettings = RouteSettings(name: widget.toString(), arguments: arguments);
    showGeneralDialog(
      context: context,
      barrierDismissible: isDialogCancel,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      routeSettings: routeSettings,
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return GestureDetector(
          onTap: () => BaseViewModel.clearAllFocus(),
          child: widget,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
