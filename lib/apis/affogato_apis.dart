library affogato.apis;

import 'dart:async';

import 'package:affogato_editor/affogato_editor.dart';
import 'package:affogato_editor/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part './extensions/extension_api.dart';
part './extensions/extensions_engine.dart';
part './events/events_api.dart';

class AffogatoAPI {
  final AffogatoExtensionsAPI extensions;

  AffogatoAPI({
    required this.extensions,
  });
}
