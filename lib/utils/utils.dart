library affogato.editor.utils;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String generateId() => String.fromCharCodes(
      Iterable.generate(
        16,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );

class AffogatoConstants {
  static const double primaryBarWidth = 350;
  static const double tabBarPadding = 6;
  static const double statusBarHeight = 24;
  static const double lineNumbersColWidth = 60;
  static const double lineNumbersGutterWidth = 20;
  static const double lineNumbersGutterRightmostPadding = 2;
  static const double overscrollAmount = 200;
  static const double breadcrumbHeight = 26;
  static const double lineHeight = 1.5;
  static const double primaryBarFileTreeIndentSize = 10;
  static const double completionsMenuItemHeight = 24;
  static const double completionsMenuWidth = 440;
  static const double searchAndReplaceRowItemHeight = 30;
  static const double searchAndReplacePadding = 4;
  static const double searchAndReplaceTextFieldWidth = 340;
  static const double searchAndReplaceWidgetWidth = 380;
}

mixin StreamSubscriptionManager<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];

  /// Wraps the `stream.listen` with two additional benefits:
  /// 1. Each [StreamSubscription] is stored so that it can be cancelled when the widget is disposed
  /// 2. The [callback] specified is only called when the widget is [mounted]
  void registerListener<E>(Stream<E> stream, void Function(E event) callback) {
    _subscriptions.add(stream.listen((e) {
      if (mounted) callback(e);
    }));
  }

  Future<void> cancelSubscriptions() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
  }
}
