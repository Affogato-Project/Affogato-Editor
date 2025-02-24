library affogato.apis;

import 'package:affogato_editor/affogato_editor.dart';
import 'package:affogato_editor/utils/utils.dart';

part 'extensions/extension_api.dart';
part './events/events_api.dart';

class AffogatoAPI {
  final AffogatoExtensionsAPI extensions;

  AffogatoAPI({
    required this.extensions,
  });
}
